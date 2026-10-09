# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    # Helper methods for determining whether and how to preview a document
    module Preview
      extend ActiveSupport::Concern

      # Reference types that are previewed via embedding
      EMBED_PREVIEWS = %i[oembed].freeze

      # Reference types that are previewed using a map viewer
      MAP_PREVIEWS = %i[
        cog dynamic_map_layer feature_layer image_map_layer index_map pmtiles
        tiled_map_layer tilejson tms wms wmts xyz
      ].freeze

      # Reference types that are previewed using a IIIF viewer
      IIIF_PREVIEWS = %i[iiif iiif_manifest].freeze

      # Whether the item viewer has anything to preview
      def previewable?
        embed_previewable? || map_previewable? || iiif_previewable?
      end

      # Tells the viewer what preview to use, if any
      def preferred_preview_type
        if embed_previewable?
          :embed
        elsif map_previewable?
          :map
        elsif iiif_previewable?
          :iiif
        end
      end

      def embed_previewable?
        any_refs_with_endpoint?(EMBED_PREVIEWS)
      end

      # Georeferenced IIIF manifests can be previewed using a map too (Allmaps)
      def map_previewable?
        any_refs_with_endpoint?(MAP_PREVIEWS) || iiif_georeferenced?
      end

      def iiif_previewable?
        any_refs_with_endpoint?(IIIF_PREVIEWS)
      end

      private

      # Are there any of the provided reference types with a non-empty URL?
      def any_refs_with_endpoint?(types)
        types.any? { |type| references.references(type)&.endpoint.present? }
      end
    end
  end
end
