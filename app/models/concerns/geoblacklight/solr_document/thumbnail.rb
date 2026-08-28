# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    # Derive a thumbnail for a document
    module Thumbnail
      IIIF_THUMBNAIL_WIDTH = 400

      # The thumbnail URL if explicitly set; otherwise derived from IIIF URL
      def thumbnail_url
        return nil unless Geoblacklight.configuration.thumbnails_enabled

        thumbnail_reference&.endpoint || iiif_thumbnail_url
      end

      private

      def thumbnail_reference
        references.find_by_uri(Geoblacklight.configuration.thumbnail_reference_key)
      end

      def iiif_image_reference
        references.iiif
      end

      # Derives an image URL from a IIIF Image API info.json endpoint. Uses the
      # sizeByW form (`w,`), which is Level 1 in both Image API v2 and v3 — unlike
      # `full` (v2 only) and `max` (v3 only), so no version sniffing is needed.
      def iiif_thumbnail_url
        endpoint = iiif_image_reference&.endpoint
        return nil unless endpoint&.end_with?("/info.json")

        base = endpoint.delete_suffix("/info.json")
        "#{base}/full/#{IIIF_THUMBNAIL_WIDTH},/0/default.jpg"
      end
    end
  end
end
