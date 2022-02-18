# frozen_string_literal: true

module Geoblacklight
  # Display facet values with a decorative icon
  # @example Usage in the blacklight configuration:
  #   config.add_facet_field 'provider_facet', [...], item_component: Geoblacklight::IconFacetItemComponent
  class IconFacetItemComponent < Blacklight::FacetItemComponent
    delegate :safe_join, :geoblacklight_icon, to: :helpers

    def initialize(facet_item:, **)
      super

      # store a copy of the original label value
      @undecorated_label = @label
    end

    def before_render
      # replace the original label with an icon-decorated version; this has to be done in
      # #before_render or #render so we have access to the icon helpers.
      @label = decorated_label

      super
    end

    private

    def decorated_label
      icon = geoblacklight_icon(@facet_item.value, aria_hidden: true, classes: 'svg_tooltip')

      safe_join([icon, @undecorated_label], ' ')
    end
  end
end
