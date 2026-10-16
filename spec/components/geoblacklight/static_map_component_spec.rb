# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::StaticMapComponent, type: :component do
  let(:document) { SolrDocument.new(id: 1) }

  subject(:rendered) do
    render_inline(described_class.new(document: document))
  end

  before do
    allow(document).to receive(:viewer_protocol).and_return("map")
    allow(Settings).to receive(:SIDEBAR_STATIC_MAP).and_return(["map"])
  end

  context "when the protocol matches the SIDEBAR_STATIC_MAP setting" do
    it "renders the static map" do
      expect(rendered.css("#static-map")).to be_present
    end
  end

  context "when deciding whether to render, from a real record" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/public_iiif_princeton.json"))) }

    before do
      allow(document).to receive(:viewer_protocol).and_call_original
      allow(Settings).to receive(:SIDEBAR_STATIC_MAP).and_return(["iiif"])
      Geoblacklight::SolrDocument.warned_preview_methods.clear
      allow(Geoblacklight.deprecation).to receive(:warn).and_call_original
    end

    it "reads the protocol without warning the application about it" do
      expect(rendered.css("#static-map")).to be_present
      expect(Geoblacklight.deprecation).not_to have_received(:warn).with(/SolrDocument#\S+ is removed in GeoBlacklight 6/, anything)
    end
  end
end
