# frozen_string_literal: true

module Geoblacklight
  class ItemMapViewerComponent < ViewComponent::Base
    def initialize(document)
      @document = document
      @pmtiles = document.item_viewer.pmtiles
      @cog = document.item_viewer.cog
      @viewer_protocol = document.viewer_protocol
      @viewer_endpoint = document.viewer_endpoint
      @wxs_identifier = document.wxs_identifier
      @geojson = document.geometry.geojson
      super
    end

    # If the conditions for this being IIIF content are met, dislay the IIIF viewer
    # Otherwise display the base viewer which will take into account if it is open layers
    # or generic content.
    def display_tag
      return iiif_tag if iiif?

      base_tag
    end

    def render?
      @document
    end

    private

    # These are captured as openlayers_container? and iiif_manifest_viewer? in geoblacklight_helper.
    def open_layers?
      @pmtiles || @cog
    end

    def iiif?
      @document&.item_viewer&.viewer_preference&.key?(:iiif_manifest)
    end

    # Generate thet tag for IIIF content
    def iiif_tag
      tag.div(nil, id: "clover-viewer", iiif_content: @viewer_endpoint)
    end

    # The only difference beween the open layers container and the regular leaflet container
    # is the id. Here we check if we need to use open layers, and set the id appropriately.
    def base_tag
      map_id = open_layers? ? "ol-map" : "map"
      tag.div(nil,
        id: map_id,
        data: {
          :map => "item", :protocol => @viewer_protocol.camelize,
          :url => @viewer_endpoint,
          "layer-id" => @wxs_identifier,
          "map-geom" => @geojson,
          "catalog-path" => helpers.search_catalog_path,
          :available => helpers.document_available?(@document),
          :basemap => helpers.geoblacklight_basemap,
          :leaflet_options => helpers.leaflet_options
        })
    end
  end
end
