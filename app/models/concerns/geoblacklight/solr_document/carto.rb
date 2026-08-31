# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    ##
    # Module for providing external Carto download references for a document
    #
    # @deprecated The Carto OneClick integration is removed without replacement
    #   in GeoBlacklight 5. Remove the `:carto` show tools partial from your
    #   CatalogController before upgrading.
    module Carto
      ##
      # Returns a url to a file that should be used with CartoDB integration
      # @return [String]
      # @deprecated
      def carto_reference
        return unless public? && download_types.try(:[], :geojson).present?
        Geoblacklight::GeojsonDownload.new(self).url_with_params
      end
      Geoblacklight.deprecation.deprecate_methods(Geoblacklight::SolrDocument::Carto,
        carto_reference: "the Carto OneClick integration is removed without replacement in GeoBlacklight 5")
    end
  end
end
