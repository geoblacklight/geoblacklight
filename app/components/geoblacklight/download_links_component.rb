# frozen_string_literal: true

module Geoblacklight
  # Display expandable file download links in sidebar
  class DownloadLinksComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:)
      @document = document
      super
    end

    def render?
      downloadable? && (document.direct_download.present? || document.iiif_download.present? || document.download_types.present?)
    end

    def downloadable?
      helpers.document_available? && @document.downloadable?
    end

    def download_link_file(label, id, url)
      link_to(
        label,
        url,
        "contentUrl" => url,
        :data => {
          download: "trigger",
          download_type: "direct",
          download_id: id
        }
      )
    end

    # Generates the link markup for the IIIF JPEG download
    # @return [String]
    def download_link_iiif
      link_to(
        download_text("JPG"),
        iiif_jpg_url,
        "contentUrl" => iiif_jpg_url,
        :data => {
          download: "trigger"
        }
      )
    end

    def download_link_generated(download_type, document)
      link_to(
        t("geoblacklight.download.export_link", download_format: export_format_label(download_type)),
        "",
        data: {
          download_path: download_path(document.id, type: download_type),
          download: "trigger",
          action: "downloads#download:once",
          download_type: download_type,
          download_id: document.id
        }
      )
    end

    ##
    # Wraps download text with proper_case_format
    #
    def download_text(format)
      download_format = proper_case_format(format)
      value = t("geoblacklight.download.download_link", download_format: download_format)
      value.html_safe
    end

    # Format labels are customized for exports - look up the appropriate key.
    def export_format_label(format)
      t("geoblacklight.download.export_#{format.to_s.parameterize(separator: "_")}_link")
    end

    # Looks up properly formatted names for formats
    def proper_case_format(format)
      return t("geoblacklight.formats.nil") unless format
      t("geoblacklight.formats.#{format.to_s.parameterize(separator: "_")}")
    end
  end
end
