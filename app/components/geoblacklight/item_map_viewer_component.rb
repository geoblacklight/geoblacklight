# frozen_string_literal: true

module Geoblacklight
  class ItemMapViewerComponent < ViewComponent::Base
    def initialize(document:)
      super()
      @document = document
    end

    # If the conditions for this being IIIF content are met, dislay the IIIF viewer
    # If it is oembed content, display the oembed viewer
    # Otherwise display the base viewer which will take into account if it is open layers
    # or generic content.
    def display_tag
      return iiif_manifest_tag if iiif_manifest?
      return iiif_image_tag if iiif_image?
      return oembed_tag if protocol == "Oembed"

      base_tag
    end

    def render?
      @document
    end

    private

    def protocol
      @document.viewer_protocol&.camelize
    end

    def openlayers?
      %w[Cog Pmtiles].include?(protocol)
    end

    def iiif_image?
      protocol == "Iiif"
    end

    def iiif_manifest?
      protocol == "IiifManifest"
    end

    # Use mirador as the IIIF manifest viewer due to bug in Clover; see:
    # https://github.com/samvera-labs/clover-iiif/issues/294
    def iiif_manifest_tag
      tag.div(nil,
        id: "mirador",
        class: "viewer",
        data: {
          manifest_url: @document.viewer_endpoint
        })
    end

    # Use openseadragon for IIIF image content due to bug in Clover; see:
    # https://github.com/samvera-labs/clover-iiif/issues/294
    def iiif_image_tag
      tag.div(nil,
        id: "openseadragon",
        class: "viewer",
        data: {
          image_url: @document.viewer_endpoint
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
      viewer_name = openlayers? ? "openlayers-viewer" : "leaflet-viewer"
      tag.div(nil,
        id: viewer_name,
        class: "viewer",
        data: {
          "controller" => viewer_name,
          "#{viewer_name}-available-value" => helpers.document_available?(@document),
          "#{viewer_name}-basemap-value" => helpers.geoblacklight_basemap,
          "#{viewer_name}-protocol-value" => protocol,
          "#{viewer_name}-url-value" => @document.viewer_endpoint,
          "#{viewer_name}-map-geom-value" => @document.geometry.geojson,
          "#{viewer_name}-layer-id-value" => @document.wxs_identifier,
          "#{viewer_name}-options-value" => helpers.leaflet_options,
          "#{viewer_name}-page-value" => params[:action]&.upcase,
          "#{viewer_name}-draw-initial-bounds-value" => true
        }.compact)
    end
  end
end
