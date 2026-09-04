# frozen_string_literal: true

require "spec_helper"

RSpec.describe GeoblacklightHelper, type: :helper do
  include BlacklightHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper

  describe "#geoblacklight_viewer_theme" do
    before do
      allow(helper).to receive(:blacklight_config).and_return(blacklight_config)
    end

    context "when dark mode support is disabled" do
      let(:blacklight_config) { Struct.new(:dark_mode_support).new(false) }

      it "states light explicitly" do
        expect(helper.geoblacklight_viewer_theme).to eq "light"
      end
    end

    context "when dark mode support is enabled" do
      let(:blacklight_config) { Struct.new(:dark_mode_support).new(true) }

      it "leaves the theme to the Bootstrap synchronizer" do
        expect(helper.geoblacklight_viewer_theme).to be_nil
      end
    end
  end

  describe "#geoblacklight_icon" do
    it "supports in use cases" do
      {
        "Paper map" => "paper-map",
        "CD ROM" => "cd-rom"
      }.each_key do |key|
        html = Capybara.string(geoblacklight_icon(key))
        expect(html).to have_xpath "//*[local-name() = 'svg']"
      end
    end
    it "handles nil values" do
      html = Capybara.string(geoblacklight_icon(nil))
      expect(html).to have_css ".icon-missing"
    end
  end

  describe "#markdown_to_html" do
    it "transforms markdown into HTML" do
      expect(helper.markdown_to_html("a **short** description")).to eq "<p>a <strong>short</strong> description</p>\n"
    end
  end

  describe "#geoblacklight_thumbnail" do
    let(:references_field) { Geoblacklight.configuration.fields.references }
    let(:document) { SolrDocument.new(document_attributes) }

    context "with a thumbnail URL" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/thumbnailUrl" => "http://example.com/thumb.jpg"
          }.to_json
        }
      end
      it "renders an image tag" do
        html = Capybara.string(helper.geoblacklight_thumbnail(document))
        expect(html).to have_css "img[src='http://example.com/thumb.jpg']"
      end
    end

    context "with only a IIIF image reference" do
      let(:document_attributes) do
        {
          references_field => {
            "http://iiif.io/api/image" => "https://iiif.example.com/iiif/2/abc%2Fdef/info.json"
          }.to_json
        }
      end
      it "renders an image tag using the URL inferred from info.json" do
        html = Capybara.string(helper.geoblacklight_thumbnail(document))
        expect(html).to have_css "img[src='https://iiif.example.com/iiif/2/abc%2Fdef/full/400,/0/default.jpg']"
      end
    end

    context "without a thumbnail URL" do
      let(:document_attributes) { {} }
      it "returns nil" do
        expect(helper.geoblacklight_thumbnail(document)).to be_nil
      end
    end

    context "when thumbnails are disabled" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/thumbnailUrl" => "http://example.com/thumb.jpg"
          }.to_json
        }
      end
      it "returns nil even though a thumbnail URL is present" do
        allow(Geoblacklight.configuration).to receive_messages(thumbnails_enabled: false)
        expect(helper.geoblacklight_thumbnail(document)).to be_nil
      end
    end
  end

  describe "#geoblacklight_default_thumbnail" do
    let(:resource_type_field) { Geoblacklight.configuration.fields.resource_type }
    let(:resource_class_field) { Geoblacklight.configuration.fields.resource_class }
    let(:document) { SolrDocument.new(document_attributes) }

    context "with a recognized data-type resource_type" do
      let(:document_attributes) { {resource_type_field => ["Raster data"]} }
      it "renders the data-type icon" do
        html = Capybara.string(helper.geoblacklight_default_thumbnail(document))
        expect(html).to have_xpath "//*[local-name() = 'svg']"
      end
    end

    context "without a matching resource_type icon, but a recognized resource_class" do
      let(:document_attributes) { {resource_class_field => ["Datasets"]} }
      it "falls back to the resource_class icon" do
        html = Capybara.string(helper.geoblacklight_default_thumbnail(document))
        expect(html).to have_xpath "//*[local-name() = 'svg']"
      end
    end

    context "with neither a recognized resource_type nor resource_class" do
      let(:document_attributes) { {resource_type_field => ["Nonexistent data"], resource_class_field => ["TotallyUnknown"]} }
      it "uses the 'missing icon' icon as a fallback" do
        expect(helper.geoblacklight_default_thumbnail(document)).to eq "<span class=\"icon-missing geoblacklight-none\"></span>"
      end
    end

    context "without any resource_type or resource_class" do
      let(:document_attributes) { {} }
      it "uses the 'missing icon' icon as a fallback" do
        expect(helper.geoblacklight_default_thumbnail(document)).to eq "<span class=\"icon-missing geoblacklight-none\"></span>"
      end
    end

    context "when thumbnails are disabled" do
      let(:document_attributes) { {resource_class_field => ["Datasets"]} }
      it "returns nil even though a matching icon exists" do
        allow(Geoblacklight.configuration).to receive_messages(thumbnails_enabled: false)
        expect(helper.geoblacklight_default_thumbnail(document)).to be_nil
      end
    end
  end

  describe "#results_js_map_selector" do
    context "viewing bookmarks" do
      let(:controller_name) { "bookmarks" }

      it "returns bookmarks data-page selector" do
        expect(results_js_map_selector(controller_name)).to eq "bookmarks"
      end
    end

    context "viewing catalog results" do
      let(:controller_name) { "catalog" }

      it "returns index data-page selector" do
        expect(results_js_map_selector(controller_name)).to eq "index"
      end
    end

    context "calling outside of intended scope" do
      let(:controller_name) { "outside" }

      it "returns default data-page value" do
        expect(results_js_map_selector(controller_name)).to eq "index"
      end
    end
  end
end
