# frozen_string_literal: true
module Geoblacklight
  module SolrDocument
    module Citation
      include ActionView::Helpers::OutputSafetyHelper

      def geoblacklight_citation(solr_document_url)
        [
          fetch(Settings.FIELDS.CREATOR, nil),
          ("(#{issued})" if issued),
          fetch(Settings.FIELDS.TITLE, nil),
          ("[#{format}]" if format),
          fetch(Settings.FIELDS.PUBLISHER, nil),
          I18n.t('geoblacklight.citation.retrieved_from', document_url: solr_document_url)
        ].flatten.compact.join('. ')
      end

      private

      def issued
        fetch(Settings.FIELDS.ISSUED, nil)
      end

      def format
        fetch(Settings.FIELDS.FILE_FORMAT, nil)
      end
    end
  end
end
