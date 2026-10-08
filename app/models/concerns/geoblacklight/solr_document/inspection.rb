# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    ##
    # Module to provide inspection logic for solr document
    module Inspection
      ##
      # Returns boolean about whether document viewer protocol is inspectable
      # @deprecated GeoBlacklight 6 removes this concern; <ogm-viewer> decides what it can inspect
      # @return [Boolean]
      def inspectable?
        Geoblacklight::SolrDocument.warn_about_preview_method(:inspectable?, caller_locations(1))
        Geoblacklight.deprecation.silence do
          %w[wms feature_layer dynamic_map_layer tiled_map_layer pmtiles]
            .include? viewer_protocol
        end
      end
    end
  end
end
