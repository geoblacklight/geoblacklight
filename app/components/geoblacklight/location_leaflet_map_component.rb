# frozen_string_literal: true

module Geoblacklight
  class LocationLeafletMapComponent < ViewComponent::Base
    def initialize(id: "leaflet-viewer", label: nil, map_geometry: Settings.HOMEPAGE_MAP_GEOM, classes: "", page: nil)
      @id = id
      @label = label
      @classes = classes
      @map_geometry = map_geometry if map_geometry != "null"
      @page = page
      super
    end

    def before_render
      @label ||= t("geoblacklight.map.label")
    end

    def search_bbox
      return unless params[:bbox].present?

      bbox = Geoblacklight::BoundingBox.new(*params[:bbox].split(" "))
      bbox.to_geojson
    end

    def viewer_tag
      tag.div(nil,
        id: @id,
        class: @classes,
        aria: {
          label: @label
        },
        data: {
          "controller" => "leaflet-viewer",
          "catalog-path" => helpers.search_catalog_path,
          "page" => @page,
          "leaflet-viewer-basemap-value" => helpers.geoblacklight_basemap,
          "leaflet-viewer-map-geom-value" => search_bbox || @map_geometry,
          "leaflet-viewer-data-map-value" => @data_map,
          "leaflet-viewer-options-value" => helpers.leaflet_options.to_json
        }.compact)
    end
  end
end
