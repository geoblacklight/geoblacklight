# frozen_string_literal: true

require "spec_helper"

describe "catalog/_show_downloads", type: :view do
  before { assign :document, document }

  context "document is downloadable" do
    let(:document) { instance_double(SolrDocument, id: 123) }
    before do
      allow(document).to receive(:restricted?).and_return(false)
      allow(document).to receive(:direct_download).and_return(test: :test)
      allow(document).to receive(:hgl_download).and_return({})
      allow(document).to receive(:iiif_download).and_return({})
      allow(document).to receive(:download_types).and_return(shapefile: {})
    end

    it "renders the downloads collapse partial" do
      expect(view).to receive(:document_downloadable?).and_return(true)
      render
      expect(rendered).to have_text('Export Shapefile')
    end
  end

  context "document is not downloadable" do
    let(:document) { instance_double(SolrDocument, restricted?: true, same_institution?: true) }
    before do
      expect(view).to receive(:document_downloadable?).and_return(false)
    end

    context "when restricted & same institution" do
      it "renders login link" do
        render
        expect(rendered).to have_css ".card-header a"
        expect(rendered).not_to have_text('Export Shapefile')
      end
    end
  end
end
