module Geoblacklight
  class SearchBuilder  < Blacklight::Solr::SearchBuilder
    self.default_processor_chain += [:add_spatial_params]

    def initialize(processor_chain, scope)
      super(processor_chain, scope)
      @processor_chain += [:add_spatial_params] unless @processor_chain.include?(:add_spatial_params)
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
        solr_params[:bq] = ["#{Settings.GEOMETRY_FIELD}:\"IsWithin(#{blacklight_params[:bbox]})\"^10"]
        solr_params[:fq] ||= []
        solr_params[:fq] << "#{Settings.GEOMETRY_FIELD}:\"Intersects(#{blacklight_params[:bbox]})\""
      end
      solr_params
    end
  end
end
