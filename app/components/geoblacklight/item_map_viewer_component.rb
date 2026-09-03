# frozen_string_literal: true

module Geoblacklight
  class ItemMapViewerComponent < ViewComponent::Base
    def initialize(document:)
      super()
      @document = document
    end

    # Use the appropriate viewer based on the protocol of the document
    def display_tag
      return oembed_tag if @document.viewer_protocol == "oembed"
      ogm_viewer_tag
    end

    def render?
      @document
    end

    private

    def oembed_tag
      tag.div(nil,
        id: "oembed-viewer",
        class: "viewer oembed-viewer",
        data: {
          controller: "oembed-viewer",
          oembed_viewer_url_value: @document.viewer_endpoint
        })
    end

    def ogm_viewer_tag
      tag.ogm_viewer(nil,
        :class => "viewer ogm-viewer",
        "hide-title" => true,
        "theme" => helpers.geoblacklight_viewer_theme,
        "light-basemap" => Geoblacklight.configuration.light_basemap_url,
        "dark-basemap" => Geoblacklight.configuration.dark_basemap_url,
        "record-url" => helpers.viewer_solr_document_path(@document),
        :data => {restricted_origins: restricted_origins})
    end

    # URLs where the viewer will send credentials (cookies) to, in order to try
    # to preview restricted data
    def restricted_origins
      origins = Geoblacklight.configuration.restricted_origins
      return if origins.blank? || !@document.restricted? || !helpers.document_available?(@document)

      origins.to_json
    end
  end
end
