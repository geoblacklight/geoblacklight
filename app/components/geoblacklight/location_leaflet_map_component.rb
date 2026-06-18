# frozen_string_literal: true

module Geoblacklight
  class LocationLeafletMapComponent < ViewComponent::Base
    def initialize(
      id: "leaflet-viewer",
      map_geometry: config.homepage_map_geom,
      classes: "",
      page: nil,
      geosearch: nil
    )
      @id = id
      @classes = classes
      @map_geometry = map_geometry if map_geometry != "null"
      @page = page
      @geosearch = geosearch
      super()
    end

    def search_bbox
      return unless params[:bbox].present?

      bbox = Geoblacklight::BoundingBox.new(*params[:bbox].split(" "))
      bbox.to_geojson
    end

    # Add top-level geosearch control to leaflet options if configured
    def leaflet_options
      config.leaflet_options.deep_dup.tap do |options|
        options.controls = {"Geosearch" => @geosearch} if @geosearch
      end
    end

    def config
      Geoblacklight.configuration
    end

    # We don't want turbo-permanent on the home page.
    def data_permanent
      return {} unless helpers.has_search_parameters?
      {turbo_permanent: true}
    end

    def viewer_tag
      tag.div(id: @id,
        class: @classes,
        data: data_permanent.merge(leaflet_viewer_data_attributes))
    end

    def leaflet_viewer_data_attributes
      {
        "controller" => "leaflet-viewer",
        "leaflet-viewer-basemap-value" => helpers.geoblacklight_basemap,
        "leaflet-viewer-map-geom-value" => search_bbox || @map_geometry,
        "leaflet-viewer-data-map-value" => @data_map,
        "leaflet-viewer-page-value" => params[:action]&.upcase,
        "leaflet-viewer-options-value" => leaflet_options.to_h,
        "leaflet-viewer-catalog-base-url-value" => (helpers.search_action_path if @geosearch)
      }.compact
    end
  end
end
