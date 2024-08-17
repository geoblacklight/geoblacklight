# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::DownloadLinksComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(component)
  end
  let(:downloadable) { true }
  let(:document) { instance_double(SolrDocument, id: 123, downloadable?: downloadable) }
  let(:component) { described_class.new(document: document) }

  before do
    allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(true)
  end

  context "when rendering is required" do
    before do
      allow(document).to receive(:direct_download).and_return(test: :test)
      allow(document).to receive(:iiif_download).and_return({})
      allow(document).to receive(:download_types).and_return(shapefile: {})
    end

    it "shows download link" do
      expect(rendered).to have_text("Download")
      expect(rendered).to have_text("Export Shapefile")
    end
  end

  context "when rendering is not required" do
    context "because there are no download links" do
      before do
        allow(document).to receive(:direct_download).and_return({})
        allow(document).to receive(:iiif_download).and_return({})
        allow(document).to receive(:download_types).and_return({})
      end

      it "does not render anything" do
        expect(rendered).not_to have_text("Download")
        expect(rendered).not_to have_text("Export Shapefile")
      end
    end

    context "because you aren't allowed" do
      let(:downloadable) { false }

      it "does not render anything" do
        expect(rendered).not_to have_text("Download")
        expect(rendered).not_to have_text("Export Shapefile")
      end
    end
  end

  describe "#download_link_file" do
    let(:label) { "Test Link Text" }
    let(:id) { "test-id" }
    let(:url) { "http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip" }

    it "generates a link to download the original file" do
      expect(component.download_link_file(label, id, url)).to eq '<a contentUrl="http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip" data-download="trigger" data-download-type="direct" data-download-id="test-id" href="http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip">Test Link Text</a>'
    end
  end

  describe "#download_link_iiif" do
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:document_attributes) do
      {
        references_field => {
          "http://iiif.io/api/image" => "https://example.edu/image/info.json"
        }.to_json
      }
    end
    let(:document) { SolrDocument.new(document_attributes, downloadable?: downloadable) }

    before do
      allow(component).to receive(:download_text).and_return("Original JPG")
      allow_any_instance_of(Geoblacklight::Reference).to receive(:to_hash).and_return(iiif: "https://example.edu/image/info.json")
    end

    it "generates a link to download the JPG file from the IIIF server" do
      expect(component.download_link_iiif).to eq '<a contentUrl="https://example.edu/image/full/full/0/default.jpg" data-download="trigger" href="https://example.edu/image/full/full/0/default.jpg">Original JPG</a>'
    end
  end

  describe "#download_link_generated" do
    let(:download_type) { "SHAPEFILE" }

    before do
      allow(component).to receive(:download_path).and_return("/download/test-id?type=SHAPEFILE")
      allow(component).to receive(:export_format_label).and_return("Shapefile Export Customization")
      allow(document).to receive(:id).and_return("test-id")
      allow(document).to receive(:to_s).and_return("test-id")
    end

    it "generates a link to download the JPG file from the IIIF server" do
      # Stub I18n to ensure the link can be customized via `export_` labels.
      allow(component).to receive(:t).with("geoblacklight.download.export_shapefile_link").and_return("Shapefile Export Customization")
      allow(component).to receive(:t).with("geoblacklight.download.export_link", {download_format: "Shapefile Export Customization"}).and_return("Export Shapefile Export Customization")
      expect(component.download_link_generated(download_type, document)).to eq '<a data-download-path="/download/test-id?type=SHAPEFILE" data-download="trigger" data-action="downloads#download:once" data-download-type="SHAPEFILE" data-download-id="test-id" href="">Export Shapefile Export Customization</a>'
    end
  end
end
