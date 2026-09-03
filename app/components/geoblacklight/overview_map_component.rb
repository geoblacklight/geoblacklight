# frozen_string_literal: true

require "rgeo"
require "rgeo-geojson"

module Geoblacklight
  # Renders a map that can show more than one record at a time, and number them
  # in the order they were provided. Use for homepage, search, bookmarks, etc.
  class OverviewMapComponent < ViewComponent::Base
    def initialize(
      map_geometry: config.homepage_map_geom,
      geosearch: false,
      id: "overview-map"
    )
      @map_geometry = map_geometry if map_geometry != "null"
      @geosearch = geosearch
      @id = id
      super()
    end

    def viewer_tag
      tag.ogm_overview(nil, **attributes)
    end

    # Hidden element containing the search bounds for the Stimulus controller
    # to parse when this component is reconnected via Turbo
    def bounds_tag
      tag.span hidden: true, id: "#{@id}-bounds", data: {bounds: search_bounds}
    end

    def config
      Geoblacklight.configuration
    end

    private

    def attributes
      {
        :id => @id,
        :class => "viewer overview-map",
        "theme" => helpers.geoblacklight_viewer_theme,
        "light-basemap" => Geoblacklight.configuration.light_basemap_url,
        "dark-basemap" => Geoblacklight.configuration.dark_basemap_url,
        "search-bounds" => search_bounds,
        "view-bounds" => view_bounds,
        "geosearch" => @geosearch || nil,
        "search-help-text" => (t("geoblacklight.map.geosearch.search_help") if @geosearch),
        "data-turbo-permanent" => true,
        :data => data_attributes
      }
    end

    def data_attributes
      {
        :controller => "overview-map",
        :action => "boundsChange->overview-map#search highlightChange->overview-map#highlight",
        "overview-map-catalog-url-value" => (helpers.search_action_path if @geosearch)
      }.compact
    end

    # The bounding box a search is currently filtered to, as W,S,E,N degrees.
    # When this is active, the camera frames it with some padding around the edges.
    def search_bounds
      params[:bbox] if params[:bbox].present?
    end

    # Where the camera should frame initially. Used for making e.g. the homepage
    # map point somewhere other than null island on initial load.
    def view_bounds
      envelope(@map_geometry) if @map_geometry.present?
    end

    # Convert geometry provided by homepage_map_geom into a bounding box that
    # we can pass to MapLibre's camera to frame.
    def envelope(geometry)
      shape = RGeo::GeoJSON.decode(geometry)
      raise "not a geometry" unless shape

      box = RGeo::Cartesian::BoundingBox.create_from_geometry(shape)
      [box.min_x, box.min_y, box.max_x, box.max_y].join(" ")
    rescue
      Geoblacklight.logger.warn "Unreadable homepage_map_geom: #{geometry}"
      nil
    end
  end
end
