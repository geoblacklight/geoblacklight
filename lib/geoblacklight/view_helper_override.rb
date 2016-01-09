module Geoblacklight
  module ViewHelperOverride
    include CatalogHelperOverride

    def spatial_parameters?
      params[:bbox]
    end

    # Overrides BL method to enable results for spatial only params
    def has_search_parameters?
      spatial_parameters? || super
    end

    def query_has_constraints?(params = params)
      has_search_parameters? || super
    end

    def render_search_to_s(params)
      super + render_search_to_s_bbox(params)
    end

    def render_search_to_s_bbox(params)
      return ''.html_safe if params['bbox'].blank?
      render_search_to_s_element('Bounding box', render_filter_value(params['bbox']))
    end

    def render_constraints_filters(params = params)
      content = super(params)

      if params[:bbox]
        content << render_constraint_element('Bounding Box',
          params[:bbox],
          remove: search_action_path(remove_spatial_filter_group(:bbox, params)))
      end

      content
    end
  end
end
