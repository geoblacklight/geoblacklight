# frozen_string_literal: true

module Geoblacklight
  module Document
    class PreviewComponent < ViewComponent::Base
      def initialize(document:)
        @document = document
        super()
      end

      # Override this to switch the viewer used for a given preview type.
      # Default is to embed embeds and use ogm-viewer for everything else.
      def display_tag
        case @document.preferred_preview_type
        when :embed
          oembed_tag
        when :map, :iiif
          ogm_viewer_tag
        end
      end

      def render?
        @document.previewable?
      end

      private

      def oembed_tag
        tag.div(nil,
          id: "oembed-viewer",
          class: "viewer oembed-viewer",
          data: {
            controller: "oembed-viewer",
            oembed_viewer_url_value: @document.oembed
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
end
