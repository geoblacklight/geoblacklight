# frozen_string_literal: true
module Geoblacklight
  module SolrDocument
    ##
    # Module to provide inspection logic for solr document
    module Inspection
      ##
      # Returns boolean about whether document viewer protocol is inspectable
      # @return [Boolean]
      def inspectable?
        %w[wms feature_layer dynamic_map_layer tiled_map_layer]
          .include? viewer_protocol
      end
    end
  end
end
