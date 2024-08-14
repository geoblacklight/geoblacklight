# frozen_string_literal: true

module Geoblacklight
  class StaticMapComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, **)
      @document = document
      super
    end

    def render?
      Settings.SIDEBAR_STATIC_MAP&.any? { |vp| @document.viewer_protocol == vp }
    end

    def before_render
      @label ||= t("geoblacklight.location")
    end

    def viewer_tag
      tag.div(nil,
        id: "static-map",
        aria: {
          label: @label
        },
        data: {
          "controller" => "leaflet-viewer",
          "leaflet-viewer-basemap-value" => helpers.geoblacklight_basemap,
          "leaflet-viewer-page-value" => "STATIC_MAP",
          "leaflet-viewer-map-geom-value" => @document.geometry.geojson,
          "leaflet-viewer-options-value" => helpers.leaflet_options,
          "leaflet-viewer-draw-initial-bounds-value" => true
        })
    end
  end
end
