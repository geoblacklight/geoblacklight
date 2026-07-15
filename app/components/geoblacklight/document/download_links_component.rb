# frozen_string_literal: true

module Geoblacklight
  module Document
    # Display expandable file download links in sidebar
    class DownloadLinksComponent < ViewComponent::Base
      attr_reader :document

      def initialize(document:)
        @document = document
        super()
      end

      def render?
        download_links.any? && helpers.document_available?(document)
      end

      def download_links
        (direct_download_links + iiif_download_links).compact
      end

      def child_component
        Geoblacklight::Document::DownloadLinkComponent
      end

      # Direct download links to files
      def direct_download_links
        direct_downloads = Array(document.direct_download&.dig(:download))
        return [] unless direct_downloads.present?

        # Use label and url for multiple downloads; use format to label otherwise
        direct_downloads.map do |entry|
          if entry.is_a?(Hash)
            child_component.new(
              title: entry["label"],
              url: entry["url"]
            )
          else
            child_component.new(
              url: entry,
              data_file_type: document.file_format
            )
          end
        end
      end

      # Links to IIIF image and manifest downloads
      def iiif_download_links
        [
          document.iiif_download.present? && child_component.new(
            title: t("geoblacklight.download.iiif_image_link"),
            url: document.iiif_download[:iiif].sub(/\/info\.json$/, "/full/full/0/default.jpg")
          ),
          document.references.iiif_manifest.present? && child_component.new(
            title: t("geoblacklight.download.iiif_manifest_link"),
            url: document.references.iiif_manifest.endpoint,
            file_type: "JSON"
          )
        ].compact_blank
      end
    end
  end
end
