# frozen_string_literal: true

module Geoblacklight
  # Display expandable file download links in sidebar
  class DownloadLinksComponent < ViewComponent::Base
    attr_reader :document, :downloadable

    def initialize(document:, downloadable:)
      @document = document
      @downloadable = downloadable
      super
    end

    def render?
      downloadable && (document.direct_download.present? || document.hgl_download.present? || document.iiif_download.present? || document.download_types.present?)
    end
  end
end
