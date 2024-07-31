# frozen_string_literal: true

module Geoblacklight
  class LocationLeafletMapComponent < ViewComponent::Base
    def initialize(
      id: "leaflet-viewer",
      map_geometry: Settings.HOMEPAGE_MAP_GEOM,
      classes: "",
      page: nil,
      geosearch: nil
    )
      @id = id
      @classes = classes
      @map_geometry = map_geometry if map_geometry != "null"
      @page = page
      @geosearch = geosearch
      super
    end

    def search_bbox
      return unless params[:bbox].present?

      bbox = Geoblacklight::BoundingBox.new(*params[:bbox].split(" "))
      bbox.to_geojson
    end

    # Add top-level geosearch control to leaflet options if configured
    def leaflet_options
      options = helpers.leaflet_options
      options["CONTROLS"] = {"Geosearch" => @geosearch} if @geosearch
      options.to_json
    end

    def viewer_tag
      tag.div(nil,
        id: @id,
        class: @classes,
        data: {
          "controller" => "leaflet-viewer",
          "leaflet-viewer-basemap-value" => helpers.geoblacklight_basemap,
          "leaflet-viewer-map-geom-value" => search_bbox || @map_geometry,
          "leaflet-viewer-data-map-value" => @data_map,
          "leaflet-viewer-options-value" => leaflet_options,
          "leaflet-viewer-catalog-base-url-value" => (helpers.search_catalog_url if @geosearch)
        }.compact)
    end
  end
end
