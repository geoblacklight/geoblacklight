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
      return oembed_tag if oembed?

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

    def oembed?
      @document.item_viewer.oembed
    end

    # Generate the viewer HTML for IIIF content
    def iiif_tag
      tag.div(nil,
        id: "clover-viewer",
        class: "viewer",
        data: {
          controller: "clover-viewer",
          clover_viewer_iiif_content_value: @document.viewer_endpoint
        })
    end

    # Generate the viewer HTML for oEmbed content
    def oembed_tag
      tag.div(nil,
        id: "oembed-viewer",
        class: "viewer",
        data: {
          controller: "oembed-viewer",
          oembed_viewer_url_value: @document.viewer_endpoint
        })
    end

    # The leaflet and openlayers viewers share a lot of the same data attributes
    # so we can use a base tag for both of them and just vary a few names
    def base_tag
      viewer_name = open_layers? ? "openlayers-viewer" : "leaflet-viewer"
      tag.div(nil,
        id: viewer_name,
        class: "viewer",
        data: {
          "controller" => viewer_name,
          "catalog-path" => helpers.search_catalog_path,
          "#{viewer_name}-available-value" => helpers.document_available?(@document),
          "#{viewer_name}-basemap-value" => helpers.geoblacklight_basemap,
          "#{viewer_name}-protocol-value" => @document.viewer_protocol.camelize,
          "#{viewer_name}-url-value" => @document.viewer_endpoint,
          "#{viewer_name}-map-geom-value" => @document.geometry.geojson,
          "#{viewer_name}-layer-id-value" => @wxs_identifier,
          "#{viewer_name}-options-value" => helpers.leaflet_options,
          "#{viewer_name}-draw-initial-bounds-value" => true
        })
    end
  end
end
