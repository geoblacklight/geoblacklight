# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ItemMapViewerComponent, type: :component do
  before do
    render_inline(described_class.new(document: document))
  end

  # One viewer for every protocol it can preview: what to show is the viewer's own decision, taken
  # from the references in the record it fetches
  ["solr_documents/iiif-eastern-hemisphere.json",
    "solr_documents/public_pmtiles_princeton.json",
    "solr_documents/actual-polygon1.json"].each do |fixture_path|
    context "with #{File.basename(fixture_path, ".json")}" do
      let(:document) { SolrDocument.new(JSON.parse(read_fixture(fixture_path))) }

      it "uses the viewer" do
        expect(page).to have_css('ogm-viewer[theme="light"]')
      end
    end
  end

  context "with an oembed record" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/oembed.json"))) }

    it "uses the oembed viewer instead" do
      expect(page).to have_css("div#oembed-viewer")
    end
  end
end
