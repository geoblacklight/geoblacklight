# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    module Citation
      include ActionView::Helpers::OutputSafetyHelper

      def geoblacklight_citation(solr_document_url)
        if Array(self[Settings.FIELDS.PUBLISHER]).size > 1
          Geoblacklight.deprecation.warn(
            "Geoblacklight::SolrDocument::Citation#geoblacklight_citation includes every value of " \
            "#{Settings.FIELDS.PUBLISHER}; GeoBlacklight 5 reads the publisher as a single value and keeps " \
            "only the first, so citations for this document will lose its other publishers"
          )
        end
        [
          fetch(Settings.FIELDS.CREATOR, nil),
          ("(#{issued})" if issued),
          fetch(Settings.FIELDS.TITLE, nil),
          ("[#{format}]" if format),
          fetch(Settings.FIELDS.PUBLISHER, nil),
          I18n.t("geoblacklight.citation.retrieved_from", document_url: solr_document_url)
        ].flatten.compact.join(". ")
      end

      private

      def issued
        fetch(Settings.FIELDS.DATE_ISSUED, nil)
      end

      def format
        fetch(Settings.FIELDS.FORMAT, nil)
      end
    end
  end
end
