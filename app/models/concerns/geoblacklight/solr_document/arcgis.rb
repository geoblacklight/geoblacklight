# frozen_string_literal: true
module Geoblacklight
  module SolrDocument
    module Arcgis
      def arcgis_urls
        return if references.esri_webservices.blank?
        references.esri_webservices.map { |layer| layer.reference[1] if layer }.compact
      end
    end
  end
end
