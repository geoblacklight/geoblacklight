# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::MetadataComponent, type: :component do
  let(:metadata) do
    instance_double(
      Geoblacklight::Metadata::Base,
      endpoint: "https://example.com/metadata.xml",
      transform: "<div>test</div>",
      type: :fgdc
    )
  end
  let(:references) { instance_double(Geoblacklight::References, shown_metadata: [metadata]) }
  let(:document) { instance_double(SolrDocument, references: references) }

  it "renders the metadata navigation and transformed content" do
    render_inline(described_class.new(document: document))

    expect(page).to have_css(".metadata-view")
    expect(page).to have_css(".pill-metadata.active[href='#fgdc']", text: "FGDC")
    expect(page).to have_css("#fgdc.tab-pane.active #metadata-container", text: "test")
  end

  context "when the metadata cannot be transformed" do
    before do
      allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::TransformError)
      allow(metadata).to receive(:to_xml).and_return("<data></data>")
    end

    it "renders the XML markup" do
      render_inline(described_class.new(document: document))

      expect(page).to have_css("#metadata-markup-container .CodeRay", text: "data")
    end
  end

  shared_examples "missing metadata" do |error_class|
    before do
      allow(metadata).to receive(:transform).and_raise(error_class)
    end

    it "renders the missing metadata message" do
      render_inline(described_class.new(document: document))

      expect(page).to have_css("#metadata-error-container")
    end
  end

  context "when the metadata cannot be parsed" do
    include_examples "missing metadata", Geoblacklight::MetadataTransformer::ParseError
  end

  context "when the metadata type is unsupported" do
    include_examples "missing metadata", Geoblacklight::MetadataTransformer::TypeError
  end

  context "with an unexpected error" do
    before do
      allow(metadata).to receive(:transform).and_raise(ArgumentError)
    end

    it "raises the error" do
      expect { render_inline(described_class.new(document: document)) }.to raise_error(ArgumentError)
    end
  end
end
