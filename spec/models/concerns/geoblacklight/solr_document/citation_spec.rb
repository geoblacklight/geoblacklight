# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::SolrDocument::Citation do
  describe '#geoblacklight_citation' do
    let(:fixture) { JSON.parse(read_fixture('solr_documents/restricted-line.json')) }
    let(:document) { SolrDocument.new(fixture) }

    it 'creates a citation' do
      expect(document.geoblacklight_citation('http://example.com'))
        .to eq 'United States. National Oceanic and Atmospheric Administration. Circuit Rider Productions. (2002). 10 Meter Contours: Russian River Basin, California. [Shapefile]. Circuit Rider Productions. Retrieved from http://example.com'
    end
  end
end
