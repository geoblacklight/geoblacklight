# frozen_string_literal: true

module Geoblacklight
  class CitationComponent < Blacklight::Document::CitationComponent
    attr_reader :document
    with_collection_parameter :document

    def initialize(document:)
      @document = document
      super
    end

    def citation
      document.geoblacklight_citation(solr_document_url(document))
    end
  end
end
