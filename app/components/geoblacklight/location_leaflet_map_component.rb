# frozen_string_literal: true

module Geoblacklight
  class LocationLeafletMapComponent < ViewComponent::Base
    def initialize(
      map_geometry: config.homepage_map_geom,
      page: nil,
      geosearch: nil
    )
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
        options.controls = {"Geosearch" => geosearch_options} if @geosearch
      end
    end

    def geosearch_options
      {
        search_here_text: I18n.t("geoblacklight.map.geosearch.search_here"),
        search_when_moved_text: I18n.t("geoblacklight.map.geosearch.search_when_moved")
      }.merge(@geosearch)
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
      tag.div(
        id: "leaflet-viewer",
        class: "viewer leaflet-viewer location-viewer",
        data: data_permanent.merge(leaflet_viewer_data_attributes)
      )
    end

    def leaflet_viewer_data_attributes
      {
        "controller" => "leaflet-viewer",
        "leaflet-viewer-basemap-value" => Geoblacklight.configuration.basemap_provider,
        "leaflet-viewer-dark-basemap-value" => Geoblacklight.configuration.dark_basemap_provider,
        "leaflet-viewer-map-geom-value" => search_bbox || @map_geometry,
        "leaflet-viewer-data-map-value" => @data_map,
        "leaflet-viewer-page-value" => @page || params[:action],
        "leaflet-viewer-options-value" => leaflet_options.to_h,
        "leaflet-viewer-catalog-base-url-value" => (helpers.search_action_path if @geosearch)
      }.compact
    end
  end
end
