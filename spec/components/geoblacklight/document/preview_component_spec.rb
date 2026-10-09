# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::PreviewComponent, type: :component do
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
        expect(page).to have_css("ogm-viewer")
      end

      it "leaves the theme to the page's color mode" do
        expect(page).to have_css("ogm-viewer:not([theme])")
      end
    end
  end

  describe "the basemap" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/actual-polygon1.json"))) }

    it "is left to the viewer's own default when none is configured" do
      expect(page).to have_css("ogm-viewer:not([light-basemap]):not([dark-basemap])")
    end

    context "when the application configures its own" do
      before do
        allow(Geoblacklight.configuration).to receive(:light_basemap_url)
          .and_return("https://tiles.example.edu/styles/light/style.json")
        render_inline(described_class.new(document: document))
      end

      it "names the style document on the viewer" do
        expect(page).to have_css('ogm-viewer[light-basemap="https://tiles.example.edu/styles/light/style.json"]')
      end
    end
  end

  describe "restricted origins in reference URLs" do
    # Restricted, and provided by this app's own institution
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/actual-raster1.json"))) }

    before do
      allow(Geoblacklight.configuration).to receive(:restricted_origins).and_return(["https://stacks.stanford.edu/"])
    end

    context "when signed in" do
      before do
        allow(vc_test_controller).to receive(:current_user).and_return(instance_double(ActiveRecord::Base))
        render_inline(described_class.new(document: document))
      end

      it "sends them to the viewer as a separate data param" do
        expect(page).to have_css('ogm-viewer[data-restricted-origins=\'["https://stacks.stanford.edu/"]\']')
      end
    end

    context "when not signed in" do
      before do
        allow(vc_test_controller).to receive(:current_user).and_return(nil)
        render_inline(described_class.new(document: document))
      end

      it "does not send them to the viewer" do
        expect(page).to have_css("ogm-viewer:not([data-restricted-origins])")
      end
    end
  end

  context "with an oembed record" do
    let(:document) { SolrDocument.new(JSON.parse(read_fixture("solr_documents/oembed.json"))) }

    it "uses the oembed viewer instead" do
      expect(page).to have_css("div#oembed-viewer")
    end

    it "hands it the oembed endpoint" do
      expect(page).to have_css("div#oembed-viewer[data-oembed-viewer-url-value='#{document.oembed}']")
    end
  end
end
