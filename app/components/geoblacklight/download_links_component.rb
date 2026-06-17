# frozen_string_literal: true

module Geoblacklight
  # Display expandable file download links in sidebar
  class DownloadLinksComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:)
      @document = document
      super()
    end

    def render?
      download_links.any?
    end

    def download_links
      (direct_download_links + generated_download_links).compact
    end

    # Direct download links to files
    def direct_download_links
      direct_downloads = Array(document.direct_download&.dig(:download))
      return [] unless direct_downloads.present?

      # Use label and url for multiple downloads; label with format otherwise
      direct_downloads.map do |entry|
        if entry.is_a?(Hash)
          link_to(entry["label"], entry["url"])
        else
          link_to(
            t(
              "geoblacklight.download.download_link",
              download_format: t(document.file_format, scope: "geoblacklight.formats", default: document.file_format)
            ),
            entry
          )
        end
      end
    end

    # Links to generated downloads from Geoserver
    def generated_download_links
      Array(document.references.downloads_by_format).map do |format, url|
        link_to(
          t(
            "geoblacklight.download.export_link",
            download_format: t(format, scope: "geoblacklight.formats", default: format)
          ),
          "",
          data: {
            download_path: download_path(document.id, type: format),
            download: "trigger",
            action: "downloads#download:once",
            download_type: format,
            download_id: document.id
          }
        )
      end
    end
  end
end
