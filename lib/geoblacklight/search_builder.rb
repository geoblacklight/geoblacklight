module Geoblacklight
  class SearchBuilder  < Blacklight::Solr::SearchBuilder
    def initialize(processor_chain, scope)
      super(processor_chain, scope)
      processor_chain << :add_spatial_params
    end

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
