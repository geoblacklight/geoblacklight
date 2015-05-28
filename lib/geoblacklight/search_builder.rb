module Geoblacklight
  class SearchBuilder  < Blacklight::Solr::SearchBuilder
    self.default_processor_chain += [:add_spatial_params]

    def initialize(processor_chain, scope)
      super(processor_chain, scope)
      @processor_chain += [:add_spatial_params] unless @processor_chain.include?(:add_spatial_params)
    end

    def add_spatial_params(solr_params)
      if blacklight_params[:bbox]
        solr_params[:bq] ||= []
        solr_params[:bq] = ["#{Settings.GEOMETRY_FIELD}:\"IsWithin(#{envelope_bounds})\"^10"]
        solr_params[:fq] ||= []
        solr_params[:fq] << "#{Settings.GEOMETRY_FIELD}:\"Intersects(#{envelope_bounds})\""
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
