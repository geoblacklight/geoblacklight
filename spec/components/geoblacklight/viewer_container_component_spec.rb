# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ViewerContainerComponent, type: :component do
  let(:document) { SolrDocument.new(fixture) }

  before do
    allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(true)
  end

  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document))
  end

  context "includes IIIF content" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/b1g_iiif_manifest.json")) }

    it "displays the IIIF help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.iiif.title"))
    end

    it "uses the IIIF tag for the container" do
      expect(rendered).to have_css("div#clover-viewer")
    end
  end

  context "includes PM Tiles content" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/public_pmtiles_princeton.json")) }

    it "displays the PM Tiles help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.pmtiles.title"))
    end

    it "uses the Open Layers tag for the container" do
      expect(rendered).to have_css("div#ol-map")
    end
  end

  context "includes general content" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/actual-polygon1.json")) }

    it "displays wms help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.wms.title"))
    end

    it "uses the Leaflet tag for the container" do
      expect(rendered).to have_css("div#map")
    end
  end

  context "includes an index map" do
    let(:fixture) { JSON.parse(read_fixture("solr_documents/index-map-stanford.json")) }

    it "displays the index map legend information" do
      expect(rendered).to have_selector(:css, ".index-map-legend-default")
      expect(rendered).to have_selector(:css, ".index-map-legend-unavailable")
      expect(rendered).to have_selector(:css, ".index-map-legend-selected")
    end

    it "uses the Leaflet tag for the container" do
      expect(rendered).to have_css("div#map")
    end
  end
end
