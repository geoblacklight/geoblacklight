# frozen_string_literal: true

module Geoblacklight
  module SolrDocument
    module Citation
      include ActionView::Helpers::OutputSafetyHelper

      def geoblacklight_citation(solr_document_url)
        [
          creator,
          ("(#{issued})" if issued),
          title,
          ("[#{format}]" if format),
          publisher,
          citation_link(solr_document_url)
        ].flatten.compact.join(". ")
      end

      private

      # The actual citation link varies based on what is available in the document
      # go through a list of potential links in order of preference, ending with the solr_document_url
      def citation_link(solr_document_url)
        identifier_url || reference_url || solr_document_url
      end

      # identifier url in solr document (if it exists)
      def identifier_url
        # find any identifier that look like a URL, return if found (could be DOI, Stanford PURL, etc)
        identifiers.find { |identifier| identifier if identifier.starts_with?("https://") }
      end

      # Examine the list of references (in dct_references_s) to find a "schema.org/url"; return URL if found
      #  References are retrieved from the SolrDocument as an array of Geoblacklight::Reference
      #  where the "reference" attribute is an array of two elements, the first being the type and the second being the url
      def reference_url
        url = references.refs.find { |ref| ref.reference[0] == "http://schema.org/url" }
        url.present? ? url.reference[1] : nil
      end
    end
  end
end
