# frozen_string_literal: true

require "spec_helper"

RSpec.describe GeoblacklightHelper, type: :helper do
  include BlacklightHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper

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

  describe "#snippit" do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Geoblacklight.configuration.fields.references }
    context "as a String" do
      let(:document_attributes) do
        {
          value: "This is a really long string that should get truncated when it gets rendered" \
                 "in the index view to give a brief description of the contents of a particular document" \
                 "indexed into Solr"
        }
      end
      it "truncates longer strings to 150 characters" do
        expect(helper.snippit(document).length).to eq 150
      end
      it "truncated string ends with ..." do
        expect(helper.snippit(document)[-3..]).to eq "..."
      end
    end
    context "as an Array" do
      let(:document_attributes) do
        {
          value: ["This is a really long string that should get truncated when it gets rendered" \
                  "in the index view to give a brief description of the contents of a particular document" \
                  "indexed into Solr"]
        }
      end
      it "truncates longer strings to 150 characters" do
        expect(helper.snippit(document).length).to eq 150
      end
      it "truncated string ends with ..." do
        expect(helper.snippit(document)[-3..]).to eq "..."
      end
    end
    context "as a multivalued Array" do
      let(:document_attributes) do
        {
          value: %w[short description]
        }
      end
      it "uses both values" do
        expect(helper.snippit(document)).to eq "short description"
      end
      it "does not truncate" do
        expect(helper.snippit(document)[-3..]).not_to eq "..."
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
