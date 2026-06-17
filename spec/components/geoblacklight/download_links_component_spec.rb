# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Document::DownloadLinksComponent, type: :component do
  let(:downloadable) { true }
  let(:direct_download) { nil }
  let(:iiif_download) { nil }
  let(:file_format) { nil }
  let(:iiif_manifest) { nil }
  let(:references) { instance_double("References", iiif_manifest: iiif_manifest) }
  let(:document) do
    instance_double(
      SolrDocument, id: 123,
      downloadable?: downloadable,
      direct_download: direct_download,
      iiif_download: iiif_download,
      file_format: file_format,
      references: references
    )
  end
  subject(:component) { described_class.new(document: document) }

  before do
    allow_any_instance_of(GeoblacklightHelper).to receive(:document_available?).and_return(true)
    render_inline(component)
  end

  context "when not downloadable" do
    let(:downloadable) { false }

    it "does not render the component" do
      is_expected.to_not be_render
    end
  end

  context "with no download links and no IIIF links" do
    it "does not render the component" do
      is_expected.to_not be_render
    end
  end

  context "with a single bare link" do
    let(:direct_download) { {download: "file.zip"} }
    let(:file_format) { "Shapefile" }

    it "renders a download link using the format to label it" do
      expect(page).to have_link("Original Shapefile", href: "file.zip")
    end

    it "renders a badge indicating the actual file type" do
      expect(page).to have_css(".badge", text: "ZIP")
    end
  end

  context "with multiple labelled download links available" do
    let(:direct_download) { {download: [{"label" => "File 1", "url" => "file.zip"}, {"label" => "File 2", "url" => "file2.json"}]} }

    it "renders a labelled download link for each" do
      expect(page).to have_link("File 1", href: "file.zip")
      expect(page).to have_css(".badge", text: "ZIP")
      expect(page).to have_link("File 2", href: "file2.json")
      expect(page).to have_css(".badge", text: "JSON")
    end
  end

  context "with a IIIF link" do
    let(:iiif_download) { {iiif: "https://example.edu/image/info.json"} }

    it "generates a link to download the JPG file from the IIIF server" do
      expect(page).to have_link(href: "https://example.edu/image/full/full/0/default.jpg")
    end
  end

  context "with a IIIF manifest link" do
    let(:iiif_manifest) { instance_double("IIIFManifest", endpoint: "https://example.edu/manifest.json") }

    it "generates a link to download the IIIF manifest" do
      expect(page).to have_link(href: "https://example.edu/manifest.json")
    end
  end

  context "with a generated download via WFS link" do
    let(:direct_download) { {download: "https://geoportal.icpac.net/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typename=geonode%3Aa__2010_TC_Bandu0&outputFormat=json&srs=EPSG%3A4326&srsName=EPSG%3A4326"} }

    it "renders a download link with the inferred file type" do
      expect(page).to have_link("Generated JSON", href: "https://geoportal.icpac.net/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typename=geonode%3Aa__2010_TC_Bandu0&outputFormat=json&srs=EPSG%3A4326&srsName=EPSG%3A4326")
    end
  end

  context "with a generated download using the format parameter" do
    let(:direct_download) { {download: "https://example.edu/file?format=CSV"} }

    it "renders a download link with the inferred file type" do
      expect(page).to have_link("Generated CSV", href: "https://example.edu/file?format=CSV")
    end
  end
end
