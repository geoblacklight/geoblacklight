module Geoblacklight
  module ViewHelperOverride
    def has_spatial_parameters?
      params[:bbox]
    end

    # Overrides BL method to enable results for spatial only params
    def has_search_parameters?
      has_spatial_parameters? || super
    end

    def query_has_contraints?(params = params)
      has_search_parameters? || super
    end

    def render_search_to_s(params)
      super + render_search_to_s_bbox(params)
    end

    def render_search_to_s_bbox(params)
      return ''.html_safe if params['bbox'].blank?
      render_search_to_s_element('Bounding box', render_filter_value(params['bbox']) )
    end
  end
end
