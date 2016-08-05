module Geoblacklight
  module SolrDocument
    ##
    # Module for providing external Carto download references for a document
    module Carto
      extend Deprecation
      self.deprecation_horizon = 'Geoblacklight 2.0.0'
      ##
      # Returns a url to a file that should be used with CartoDB integration
      # @return [String]
      # @deprecated Use {#carto_reference} instead
      def cartodb_reference
        carto_reference
      end
      deprecation_deprecate(
        cartodb_reference: 'use Geoblacklight::SolrDocument::Carto#carto_reference instead'
      )

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
