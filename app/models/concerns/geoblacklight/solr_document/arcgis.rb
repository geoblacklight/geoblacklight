module Geoblacklight
  module SolrDocument
    module Arcgis
      def arcgis_urls
        return unless references.esri_webservices.present?
        references.esri_webservices.map { |layer| layer.reference[1] if layer }.compact
      end
    end
  end
end
