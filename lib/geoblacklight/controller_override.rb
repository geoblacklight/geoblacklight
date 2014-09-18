module Geoblacklight
  module ControllerOverride
    extend ActiveSupport::Concern
    included do
      solr_search_params_logic << :add_spatial_params
    end
    
    def add_spatial_params(solr_params, req_params)
      if req_params[:bbox]
        solr_params[:q] ||= "*"
        solr_params[:q] += " solr_bbox:\"IsWithin(#{req_params[:bbox]})\"^10"
        solr_params[:fq] ||= []
        solr_params[:fq] << "solr_bbox:\"Intersects(#{req_params[:bbox]})\""
      end
      solr_params
    end
  end
end