# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ItemMapViewerComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document))
  end

  context "IIIF viewer" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/iiif-eastern-hemisphere.json")) }
    let(:document) { SolrDocument.new(fixture) }

    it "uses the IIIF tag" do
      expect(rendered).to have_css("div#clover-viewer")
    end
  end

  context "Open layers viewer" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/public_pmtiles_princeton.json")) }
    let(:document) { SolrDocument.new(fixture) }

    it "uses the open layers tag" do
      expect(rendered).to have_css("div#openlayers-viewer")
    end
  end

  context "Base or leaflet viewer" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/actual-polygon1.json")) }
    let(:document) { SolrDocument.new(fixture) }

    it "uses the IIIF tag" do
      expect(rendered).to have_css("div#leaflet-viewer")
    end
  end
end
