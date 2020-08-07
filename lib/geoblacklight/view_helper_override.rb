# frozen_string_literal: true
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

    def query_has_constraints?(localized_params = params)
      has_search_parameters? || super(localized_params)
    end

    def render_search_to_s(params)
      super + render_search_to_s_bbox(params)
    end

    def render_search_to_s_bbox(params)
      return ''.html_safe if params['bbox'].blank?
      render_search_to_s_element(t('geoblacklight.bbox_label'), render_filter_value(params['bbox']))
    end

    def render_constraints_filters(localized_params = params)
      content = super(localized_params)
      localized_params = localized_params.to_unsafe_h if localized_params.respond_to?(:to_unsafe_h)

      if localized_params[:bbox]
        path = search_action_path(remove_spatial_filter_group(:bbox, localized_params))
        content << render_constraint_element(t('geoblacklight.bbox_label'),
                                             localized_params[:bbox], remove: path)
      end

      content
    end
  end
end
