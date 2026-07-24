# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::CitationComponent, type: :component do
  describe "#geoblacklight_citation" do
    let(:document) { SolrDocument.new(fixture) }

    before do
      render_inline(described_class.new(document: document))
    end

    context "when the identifier is a URL" do
      let(:fixture) { JSON.parse(read_fixture("solr_documents/restricted-line.json")) }

      it "creates a citation with the identifier link" do
        expect(page)
          .to have_text "East View Geospatial. (2010-04-01). Roads, Port-au-Prince, Haiti, 2010. [Shapefile]. East View Geospatial. https://spatial.lib.berkeley.edu/viewpublic/berkeley-s76d73"
      end
    end

    context "when the identifier is not a URL but a reference schema.org URL is available" do
      let(:fixture) { JSON.parse(read_fixture("solr_documents/tilejson.json")) }

      it "creates a citation with the schema.org references link" do
        expect(page)
          .to have_text "Great Britain. War Office. General Staff. Geographical Section. (1908). The Balkans [and] Turkey : G.S.G.S. no. 2097 / War Office. General Staff. Geographical Section (TileJSON Fixture). [London] : War Office. General Staff. Geographical Section. General Staff, 1908-25.. https://catalog.princeton.edu/catalog/99125413918506421"
      end
    end

    context "when the identifier is not a URL and no reference schema.org URL is available" do
      let(:fixture) { JSON.parse(read_fixture("solr_documents/no_spatial.json")) }

      it "creates a citation with the solr document link" do
        expect(page)
          .to have_text "ASTER Global Emissivity Dataset 1-kilometer V003 - AG1KM. http://test.host/catalog/aster-global-emissivity-dataset-1-kilometer-v003-ag1kmcad20"
      end
    end
  end
end
