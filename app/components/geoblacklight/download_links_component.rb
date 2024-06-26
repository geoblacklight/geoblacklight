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
      document.direct_download.present? || document.hgl_download.present? || document.iiif_download.present? || document.download_types.present?
    end
  end
end
