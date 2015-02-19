module Geoblacklight
  module ControllerOverride
    extend ActiveSupport::Concern
    included do
      solr_search_params_logic << :add_spatial_params
    end

    def add_spatial_params(solr_params, req_params)
      if req_params[:bbox]
        solr_params[:bq] ||= []
        solr_params[:bq] = ["#{Settings.GEOMETRY_FIELD}:\"IsWithin(#{req_params[:bbox]})\"^10"]
        solr_params[:fq] ||= []
        solr_params[:fq] << "#{Settings.GEOMETRY_FIELD}:\"Intersects(#{req_params[:bbox]})\""
      end
      solr_params
    end

    def web_services
      @response, @document = get_solr_response_for_doc_id params[:id]
    end
  end
end