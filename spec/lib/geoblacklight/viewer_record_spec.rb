# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::ViewerRecord do
  let(:references_field) { Geoblacklight.configuration.fields.references }
  let(:references) do
    {
      "http://www.opengis.net/def/serviceType/ogc/wms" => "https://geoservices-secure.example.edu/geoserver/wms",
      "http://schema.org/downloadUrl" => "https://example.edu/data.zip",
      # Spelled with the trailing slash a record may use, where Constants::URI has none
      "http://www.isotc211.org/schemas/2005/gmd/" => "https://example.edu/iso19139.xml",
      "http://schema.org/url" => "https://example.edu/catalog/example-1",
      "http://lccn.loc.gov/sh85035852" => "https://example.edu/dictionary.csv"
    }
  end
  let(:document) do
    SolrDocument.new(
      "id" => "example-1",
      "dct_accessRights_s" => "Restricted",
      "gbl_wxsIdentifier_s" => "example",
      references_field => references.to_json
    )
  end

  describe "#as_json" do
    subject(:record) { described_class.new(document, available: available).as_json }

    context "when the data is available to the reader" do
      let(:available) { true }

      it "hands over the record as indexed" do
        expect(record).to eq document.as_json
      end
    end

    context "when the data is not available to the reader" do
      let(:available) { false }
      let(:kept) { JSON.parse(record[references_field]) }

      it "keeps the references that describe the record, spelled as the record spelled them" do
        expect(kept).to eq(
          "http://www.isotc211.org/schemas/2005/gmd/" => "https://example.edu/iso19139.xml",
          "http://schema.org/url" => "https://example.edu/catalog/example-1",
          "http://lccn.loc.gov/sh85035852" => "https://example.edu/dictionary.csv"
        )
      end

      it "withholds the references that deliver its data" do
        expect(kept.keys).not_to include(
          "http://www.opengis.net/def/serviceType/ogc/wms",
          "http://schema.org/downloadUrl"
        )
      end

      it "leaves the rest of the record alone" do
        expect(record.except(references_field)).to eq document.as_json.except(references_field)
      end

      context "with a record that names no references at all" do
        let(:document) { SolrDocument.new("id" => "example-2") }

        it "doesn't invent an empty references field" do
          expect(record).not_to have_key(references_field)
        end
      end
    end
  end
end
