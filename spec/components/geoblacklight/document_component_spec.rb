# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::DocumentComponent, type: :component do
  subject(:component) { described_class.new(document: document, show: true) }

  let(:view_context) { vc_test_controller.view_context }
  let(:rendered) { render_inline_to_capybara_node(component) }
  let(:document) { view_context.document_presenter(presented_document) }
  let(:presented_document) { SolrDocument.new(JSON.parse(read_fixture(fixture))) }
  let(:fixture) { "solr_documents/actual-polygon1.json" }

  let(:blacklight_config) do
    CatalogController.blacklight_config.deep_copy.tap do |config|
      config.track_search_session.storage = false
      config.index.thumbnail_field = "thumbnail_path_ss"
      config.index.document_actions[:bookmark].partial = "/catalog/bookmark_control"
    end
  end

  before do
    vc_test_controller.action_name = "show"
    allow(vc_test_controller).to receive_messages(view_context: view_context, current_or_guest_user: User.new, blacklight_config: blacklight_config)
    allow(view_context).to receive_messages(search_session: {}, current_search_session: nil, current_bookmarks: [])
  end

  it "does not render any display notes" do
    expect(rendered).not_to have_css(".gbl-display-note")
  end

  it "does not render index map content" do
    expect(rendered).not_to have_css(".index-map-legend")
    expect(rendered).not_to have_css(".viewer-information")
  end

  context "when the document has display notes" do
    let(:fixture) { "solr_documents/display-note.json" }

    it "renders the display notes" do
      expect(rendered).to have_css(".gbl-display-note")
    end
  end

  context "when the document is an index map" do
    let(:fixture) { "solr_documents/index-map-stanford.json" }

    it "renders the index map legend" do
      expect(rendered).to have_css(".index-map-legend")
    end

    it "renders the index map inspection area" do
      expect(rendered).to have_css(".viewer-information")
    end
  end

  context "when the document has a IIIF manifest" do
    let(:fixture) { "solr_documents/b1g_iiif_manifest.json" }

    it "displays the IIIF help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.iiif.title"))
    end

    it "uses the IIIF tag for the container" do
      expect(rendered).to have_css("div#mirador")
    end
  end

  context "when the document has a pmtiles layer" do
    let(:fixture) { "solr_documents/public_pmtiles_princeton.json" }

    it "displays the PM Tiles help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.pmtiles.title"))
    end

    it "uses the Open Layers tag for the container" do
      expect(rendered).to have_css("div#openlayers-viewer")
    end
  end

  context "when the document has a WMS layer" do
    let(:fixture) { "solr_documents/actual-polygon1.json" }

    it "displays wms help text" do
      expect(rendered).to have_text(I18n.t("geoblacklight.help_text.viewer_protocol.wms.title"))
    end

    it "uses the Leaflet tag for the container" do
      expect(rendered).to have_css("div#leaflet-viewer")
    end
  end
end
