# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::SolrDocument::Thumbnail do
  let(:document) { SolrDocument.new(document_attributes) }
  let(:references_field) { Geoblacklight.configuration.fields.references }

  # A realistic IIIF Image API endpoint: Princeton's identifiers are
  # percent-encoded, which the derivation must leave untouched.
  let(:iiif_info) do
    "https://iiif-cloud.princeton.edu/iiif/2/b3%2F2f%2F74%2Fb32f74ac13e243de89e1af175a4076d0%2Fintermediate_file/info.json"
  end
  let(:iiif_base) do
    "https://iiif-cloud.princeton.edu/iiif/2/b3%2F2f%2F74%2Fb32f74ac13e243de89e1af175a4076d0%2Fintermediate_file"
  end

  describe "#thumbnail_url" do
    describe "with a thumbnail reference at the default key" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/thumbnailUrl" => "http://example.com/thumb.jpg"
          }.to_json
        }
      end
      it "returns the thumbnail URL" do
        expect(document.thumbnail_url).to eq "http://example.com/thumb.jpg"
      end
    end

    describe "without a dct_references_s field" do
      let(:document_attributes) { {} }
      it "returns nil" do
        expect(document.thumbnail_url).to be_nil
      end
    end

    describe "with a dct_references_s field missing the thumbnail key" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/url" => "http://example.com/homepage"
          }.to_json
        }
      end
      it "returns nil" do
        expect(document.thumbnail_url).to be_nil
      end
    end

    describe "with a configured thumbnail_reference_key" do
      let(:document_attributes) do
        {
          references_field => {
            "http://example.com/custom-thumbnail-key" => "http://example.com/custom-thumb.jpg"
          }.to_json
        }
      end
      it "resolves the configured key instead of the default" do
        allow(Geoblacklight.configuration).to receive_messages(
          thumbnail_reference_key: "http://example.com/custom-thumbnail-key"
        )
        expect(document.thumbnail_url).to eq "http://example.com/custom-thumb.jpg"
      end
    end

    describe "when thumbnails are disabled" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/thumbnailUrl" => "http://example.com/thumb.jpg"
          }.to_json
        }
      end
      it "returns nil even though a thumbnail reference is present" do
        allow(Geoblacklight.configuration).to receive_messages(thumbnails_enabled: false)
        expect(document.thumbnail_url).to be_nil
      end
    end

    describe "with a IIIF image reference and no thumbnail reference" do
      let(:document_attributes) do
        {references_field => {"http://iiif.io/api/image" => iiif_info}.to_json}
      end

      it "infers the thumbnail URL from the info.json endpoint" do
        expect(document.thumbnail_url).to eq "#{iiif_base}/full/400,/0/default.jpg"
      end

      it "requests a size supported by both Image API v2 and v3" do
        size = document.thumbnail_url[%r{/full/([^/]+)/0/default\.jpg\z}, 1]

        # sizeByW is Level 1 in both v2.1 and v3.0. `full` is invalid in v3 and
        # `max` is optional in v2, so neither is safe without version sniffing.
        expect(size).to eq "400,"
        expect(size).not_to eq "full"
        expect(size).not_to eq "max"
      end

      it "preserves the percent-encoded identifier" do
        expect(document.thumbnail_url).to include "b3%2F2f%2F74%2F"
      end
    end

    describe "with both a thumbnail reference and a IIIF image reference" do
      let(:document_attributes) do
        {
          references_field => {
            "http://schema.org/thumbnailUrl" => "http://example.com/thumb.jpg",
            "http://iiif.io/api/image" => iiif_info
          }.to_json
        }
      end
      it "prefers the explicit thumbnail reference" do
        expect(document.thumbnail_url).to eq "http://example.com/thumb.jpg"
      end
    end

    describe "with a IIIF image reference that is not an info.json URL" do
      let(:document_attributes) do
        {references_field => {"http://iiif.io/api/image" => iiif_base}.to_json}
      end
      it "returns nil rather than deriving a broken URL" do
        expect(document.thumbnail_url).to be_nil
      end
    end

    describe "with only a IIIF presentation manifest reference" do
      let(:document_attributes) do
        {
          references_field => {
            "http://iiif.io/api/presentation#manifest" => "https://purl.stanford.edu/hj948rn6493/iiif3/manifest"
          }.to_json
        }
      end
      it "returns nil, since a manifest is not an Image API endpoint" do
        expect(document.thumbnail_url).to be_nil
      end
    end

    describe "with an unparseable dct_references_s field" do
      let(:document_attributes) { {references_field => "not json"} }
      it "returns nil" do
        expect(document.thumbnail_url).to be_nil
      end
    end
  end
end
