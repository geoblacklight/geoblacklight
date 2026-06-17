# frozen_string_literal: true

module Geoblacklight
  module Document
    # A single resource available for download on a record
    class DownloadLinkComponent < ViewComponent::Base
      attr_reader :url

      # @param url [String] the URL of the download link
      # @param title [String, nil] the title of the download link
      # @param file_type [String, nil] file type for what will be downloaded (e.g. zip)
      # @param data_file_type [String, nil] file type for the actual data (e.g. Shapefile)
      def initialize(url:, title: nil, file_type: nil, data_file_type: nil)
        @url = url
        @title = title
        @file_type = file_type
        @data_file_type = data_file_type
        super()
      end

      # Use format to label the download if no title is provided
      def title
        @title || generated_title_from_format || title_from_format
      end

      # Infer the file type from the URL if not provided
      def file_type
        @file_type || wfs_file_type || requested_file_type || file_extension
      end

      private

      def format_label
        t(@data_file_type&.downcase || file_type, scope: "geoblacklight.formats", default: @data_file_type || file_type)
      end

      def title_from_format
        t("geoblacklight.download.original_link", download_format: format_label)
      end

      def generated_title_from_format
        t("geoblacklight.download.generated_link", download_format: format_label) if generated?
      end

      def file_extension
        File.extname(url).delete(".").upcase
      end

      def requested_file_type
        url.match(/format=([^&]+)/)&.captures&.first&.upcase
      end

      def wfs_file_type
        url.match(/outputFormat=([^&]+)/)&.captures&.first&.upcase if generated_via_wfs?
      end

      def generated?
        url.match?(/format=([^&]+)/) || generated_via_wfs?
      end

      def generated_via_wfs?
        url.match?(/service=WFS/i)
      end
    end
  end
end
