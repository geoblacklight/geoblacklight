# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::SolrDocument::Citation do
  describe "#geoblacklight_citation" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/restricted-line.json")) }
    let(:document) { SolrDocument.new(fixture) }

    it "creates a citation" do
      expect(document.geoblacklight_citation("http://example.com"))
        .to eq "East View Geospatial. (2010-04-01). Roads, Port-au-Prince, Haiti, 2010. [Shapefile]. East View Geospatial. https://spatial.lib.berkeley.edu/viewpublic/berkeley-s76d73"
    end
  end
end
