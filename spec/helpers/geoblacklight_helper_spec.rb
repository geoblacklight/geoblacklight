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

  describe "#render_value_as_truncate_abstract" do
    context "with multiple values" do
      let(:document) { SolrDocument.new(value: %w[short description]) }
      it "wraps in correct DIV class" do
        expect(helper.render_value_as_truncate_abstract(document)).to eq '<div class="truncate-abstract" data-read-more-text="Read more" data-close-text="Close"><p>short</p><p>description</p></div>'
      end
    end
  end

  describe "#render_transformed_metadata" do
    let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }
    context "with valid XML data" do
      before do
        allow(metadata).to receive(:transform).and_return("<div>test</div>")
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render)
          .with(partial: "catalog/metadata/content", locals: {content: "<div>test</div>"})
        helper.render_transformed_metadata(metadata)
      end
    end

    context "with valid XML data without an HTML transform" do
      before do
        allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::TransformError)
        allow(metadata).to receive(:to_xml).and_return("<data></data>")
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render).with(partial: "catalog/metadata/markup",
          locals: {content: "<data></data>"})
        helper.render_transformed_metadata(metadata)
      end
    end

    context "without XML data" do
      before do
        allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::ParseError)
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render).with(partial: "catalog/metadata/missing")
        helper.render_transformed_metadata(metadata)
      end
    end

    context "with an unsupported metadata type" do
      before do
        allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::TypeError)
      end

      it "renders the missing metadata partial" do
        expect(helper).to receive(:render).with(partial: "catalog/metadata/missing")
        helper.render_transformed_metadata(metadata)
      end
    end

    context "with an unexpected error" do
      before do
        allow(metadata).to receive(:transform).and_raise(ArgumentError)
      end

      it "raises the error" do
        expect { helper.render_transformed_metadata(metadata) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#first_metadata?" do
    let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }
    let(:references) { instance_double(Geoblacklight::References) }
    let(:document) { instance_double(SolrDocument) }

    before do
      allow(document).to receive(:references).and_return(references)
      allow(references).to receive(:shown_metadata).and_return([metadata])
      allow(metadata).to receive(:type).and_return("fgdc")
    end

    it "confirms that a metadata resource is the first item reference" do
      expect(helper.first_metadata?(document, metadata)).to be true
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
