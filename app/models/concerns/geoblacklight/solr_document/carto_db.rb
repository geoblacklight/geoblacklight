module Geoblacklight
  module SolrDocument
    ##
    # Module for providing external CartoDB download references for a document
    module CartoDb
      ##
      # Returns a url to a file that should be used with CartoDB integration
      # @return [String]
      def cartodb_reference
        return unless public? && download_types.try(:[], :geojson).present?
        Geoblacklight::GeojsonDownload.new(self).url_with_params
      end
    end
  end
end
