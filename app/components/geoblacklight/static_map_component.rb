# frozen_string_literal: true

module Geoblacklight
  class StaticMapComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, **)
      @document = document
      super()
    end

    # If there's no preview using the big map, or there is a IIIF preview that
    # is not georeferenced, we need to see where the item is located.
    def render?
      !@document.previewable? || (@document.iiif_preview? && !@document.georeferenced?)
    end

    def before_render
      @label ||= t("geoblacklight.location")
    end

    def viewer_tag
      leaflet_options = Geoblacklight.configuration.leaflet_options.deep_dup
      leaflet_options.sleep.sleep = false
      tag.div(nil,
        id: "static-map",
        class: "viewer border",
        data: {
          "controller" => "leaflet-viewer",
          "leaflet-viewer-basemap-value" => Geoblacklight.configuration.basemap_provider,
          "leaflet-viewer-dark-basemap-value" => Geoblacklight.configuration.dark_basemap_provider,
          "leaflet-viewer-page-value" => "STATIC_MAP",
          "leaflet-viewer-map-geom-value" => @document.geometry.geojson,
          "leaflet-viewer-options-value" => leaflet_options.to_h,
          "leaflet-viewer-draw-initial-bounds-value" => true
        })
    end
  end
end
