# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::CitationComponent, type: :component do
  describe "#geoblacklight_citation" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/restricted-line.json")) }
    let(:document) { SolrDocument.new(fixture) }
    let(:rendered) { render_inline_to_capybara_node(described_class.new(document: document)) }

    it "creates a citation" do
      expect(rendered)
        .to have_text "United States. National Oceanic and Atmospheric Administration. Circuit Rider Productions. (2002). 10 Meter Contours: Russian River Basin, California. [Shapefile]. Circuit Rider Productions. Retrieved from http://test.host/catalog/stanford-cg357zz0321"
    end
  end
end
