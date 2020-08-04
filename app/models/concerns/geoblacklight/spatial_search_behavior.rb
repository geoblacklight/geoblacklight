module Geoblacklight
  module SpatialSearchBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:add_spatial_params, :hide_suppressed_records]
    end

    ##
    # Adds spatial parameters to a Solr query if :bbox is present.
    # @param [Blacklight::Solr::Request] solr_params :bbox should be in Solr
    # :bbox should be passed in using Solr lat-lon rectangle format e.g.
    # "minX minY maxX maxY"
    # @return [Blacklight::Solr::Request]
    def add_spatial_params(solr_params)
      if blacklight_params[:bbox]
        solr_params[:bq] ||= []
        solr_params[:bq] << "#{Settings.FIELDS.GEOMETRY}:\"IsWithin(#{envelope_bounds})\"#{boost}"
        solr_params[:fq] ||= []
        solr_params[:fq] << "#{Settings.FIELDS.GEOMETRY}:\"Intersects(#{envelope_bounds})\""

        if Settings.OVERLAP_RATIO_BOOST
          solr_params[:bf] ||= []
          solr_params[:overlap] =
            "{!field uf=* defType=lucene f=solr_bboxtype score=overlapRatio}Intersects(#{envelope_bounds})"
          solr_params[:bf] << "$overlap^#{Settings.OVERLAP_RATIO_BOOST}"
        end
      end
      solr_params
    rescue Geoblacklight::Exceptions::WrongBoundingBoxFormat
      # TODO: Potentially delete bbox params here so that its not rendered as search param
      solr_params
    end

    ##
    # @return [String]
    def envelope_bounds
      bounding_box.to_envelope
    end

    ## Allow bq boost to be configured, default 10 for backwards compatibility
    # @return [String]
    def boost
      "^#{Settings.BBOX_WITHIN_BOOST || '10'}"
    end

    ##
    # Returns a Geoblacklight::BoundingBox built from the blacklight_params
    # @return [Geoblacklight::BoundingBox]
    def bounding_box
      Geoblacklight::BoundingBox.from_rectangle(blacklight_params[:bbox])
    end

    ##
    # Hide suppressed records in search
    # @param [Blacklight::Solr::Request]
    # @return [Blacklight::Solr::Request]
    def hide_suppressed_records(solr_params)
      # Show child records if searching for a specific source parent
      return unless blacklight_params.fetch(:f, {})[Settings.FIELDS.SOURCE.to_sym].nil?

      # Do not suppress action_documents method calls for individual documents
      # ex. CatalogController#web_services (exportable views)
      return if solr_params[:q]&.include?('{!lucene}layer_slug_s:')

      solr_params[:fq] ||= []
      solr_params[:fq] << '-suppressed_b: true'
    end
  end
end
