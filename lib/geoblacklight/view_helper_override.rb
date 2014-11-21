module Geoblacklight
  module ViewHelperOverride
    
    def has_spatial_parameters?
      params[:bbox]
    end
    
    # Overrides BL method to enable results for spatial only params
    def has_search_parameters?
      super || has_spatial_parameters?
    end
    
    def query_has_contraints?(params = params)
      super || has_search_parameters?
    end
  end
end