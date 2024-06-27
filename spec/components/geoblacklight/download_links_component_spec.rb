# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::DownloadLinksComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(document: document, downloadable: downloadable))
  end
  let(:document) { instance_double(SolrDocument, id: 123) }

  context "when rendering is required" do
    let(:downloadable) { true }

    before do
      allow(document).to receive(:direct_download).and_return(test: :test)
      allow(document).to receive(:hgl_download).and_return({})
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
      let(:downloadable) { true }
      before do
        allow(document).to receive(:direct_download).and_return({})
        allow(document).to receive(:hgl_download).and_return({})
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
end
