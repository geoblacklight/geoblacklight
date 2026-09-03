# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::LocatorMapComponent, type: :component do
  let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/actual-polygon1.json"))) }

  subject(:map) { page.find("ogm-locator") }

  before { render_inline(described_class.new(document: document)) }

  it "renders a locator the stylesheet can size" do
    expect(map[:id]).to eq "locator-map"
    expect(map[:class]).to eq "viewer locator-map"
  end

  it "points at the same record endpoint the item viewer reads" do
    expect(map["record-url"]).to be_present
  end

  it "states Bootstrap's light default when dark mode support is unavailable" do
    expect(map[:theme]).to eq "light"
  end

  describe "the basemap" do
    it "is left to the viewer's own default when none is configured" do
      expect(map["light-basemap"]).to be_nil
      expect(map["dark-basemap"]).to be_nil
    end

    context "when the application configures its own" do
      before do
        allow(Geoblacklight.configuration).to receive(:dark_basemap_url)
          .and_return("https://tiles.example.edu/styles/dark/style.json")
        render_inline(described_class.new(document: document))
      end

      it "names the style document on the locator too, so every map on the page matches" do
        expect(map["dark-basemap"]).to eq "https://tiles.example.edu/styles/dark/style.json"
      end
    end
  end
end
