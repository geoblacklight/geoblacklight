# frozen_string_literal: true
module Geoblacklight
  # Override Blacklight helpers to inject behavior
  module ViewHelperOverride
    def render_search_to_s(params)
      super + render_search_to_s_bbox(params)
    end

    def render_search_to_s_bbox(params)
      return ''.html_safe if params['bbox'].blank?

      render_search_to_s_element(t('geoblacklight.bbox_label'), render_filter_value(params['bbox']))
    end
  end
end
