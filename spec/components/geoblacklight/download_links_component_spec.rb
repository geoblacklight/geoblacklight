# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::DownloadLinksComponent, type: :component do
  let(:downloadable) { true }
  let(:direct_download) { nil }
  let(:iiif_download) { nil }
  let(:file_format) { nil }
  let(:document) do
    instance_double(
      SolrDocument, id: 123,
      downloadable?: downloadable,
      direct_download: direct_download,
      iiif_download: iiif_download,
      file_format: file_format
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
  end

  context "with multiple labelled download links available" do
    let(:direct_download) { {download: [{"label" => "File 1", "url" => "file.zip"}, {"label" => "File 2", "url" => "file2.json"}]} }

    it "renders a labelled download link for each" do
      expect(page).to have_link("File 1", href: "file.zip")
      expect(page).to have_link("File 2", href: "file2.json")
    end
  end

  context "with a IIIF link" do
    let(:iiif_download) { {iiif: "https://example.edu/image/info.json"} }

    it "generates a link to download the JPG file from the IIIF server" do
      expect(page).to have_link("Original JPG", href: "https://example.edu/image/full/full/0/default.jpg")
    end
  end
end
