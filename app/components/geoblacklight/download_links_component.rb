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
      downloadable? && (document.direct_download.present? || document.iiif_download.present?)
    end

    def downloadable?
      helpers.document_available?(@document) && @document.downloadable?
    end

    ##
    # Wraps download text with proper_case_format
    #
    def download_text(format)
      download_format = proper_case_format(format)
      value = t("geoblacklight.download.download_link", download_format: download_format)
      value.html_safe
    end

    # Looks up properly formatted names for formats
    def proper_case_format(format)
      t("geoblacklight.formats.#{format.to_s.parameterize(separator: "_")}")
    end

    def iiif_jpg_url
      @document.iiif_download[:iiif].sub "info.json", "full/full/0/default.jpg"
    end
  end
end
