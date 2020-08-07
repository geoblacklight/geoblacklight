# frozen_string_literal: true
module Geoblacklight
  module SolrDocument
    ##
    # Module for providing external Carto download references for a document
    module Carto
      ##
      # Returns a url to a file that should be used with CartoDB integration
      # @return [String]
      def carto_reference
        return unless public? && download_types.try(:[], :geojson).present?
        Geoblacklight::GeojsonDownload.new(self).url_with_params
      end
    end
  end
end
