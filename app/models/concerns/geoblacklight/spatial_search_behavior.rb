module Geoblacklight
  module SpatialSearchBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:add_spatial_params]
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
        solr_params[:bq] = ["#{Settings.FIELDS.GEOMETRY}:\"IsWithin(#{envelope_bounds})\"^10"]
        solr_params[:fq] ||= []
        solr_params[:fq] << "#{Settings.FIELDS.GEOMETRY}:\"Intersects(#{envelope_bounds})\""
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

    ##
    # Returns a Geoblacklight::BoundingBox built from the blacklight_params
    # @return [Geoblacklight::BoundingBox]
    def bounding_box
      Geoblacklight::BoundingBox.from_rectangle(blacklight_params[:bbox])
    end
  end
end
