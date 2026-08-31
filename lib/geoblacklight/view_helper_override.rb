# frozen_string_literal: true

module Geoblacklight
  # Override Blacklight helpers to inject behavior
  #
  # @deprecated This module is removed in GeoBlacklight 5. Blacklight renders
  #   saved search constraints through Blacklight::ConstraintsComponent, and the
  #   bbox constraint is supplied by Geoblacklight::BboxItemPresenter.
  module ViewHelperOverride
    # This overrides Blacklight's own helper, so Blacklight calls it on every
    # search history page even in an unmodified application. Warning here would
    # be noise, so only the GeoBlacklight-specific method below is deprecated,
    # and this call to it is silenced.
    def render_search_to_s(params)
      super + Geoblacklight.deprecation.silence { render_search_to_s_bbox(params) }
    end

    # @deprecated
    def render_search_to_s_bbox(params)
      return "".html_safe if params["bbox"].blank?

      render_search_to_s_element(t("geoblacklight.bbox_label"), render_filter_value(params["bbox"]))
    end
    Geoblacklight.deprecation.deprecate_methods(Geoblacklight::ViewHelperOverride,
      render_search_to_s_bbox: "use Blacklight::ConstraintsComponent instead")
  end
end
