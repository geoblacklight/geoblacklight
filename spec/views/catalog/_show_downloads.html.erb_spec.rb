# frozen_string_literal: true
require 'spec_helper'

describe 'catalog/_show_downloads.html.erb', type: :view do
  context 'document is downloadable' do
    let(:document) { instance_double(SolrDocument) }
    before do
      assign :document, document

      allow(document).to receive(:restricted?).and_return(false)
      allow(document).to receive(:direct_download).and_return(test: :test)
      allow(document).to receive(:hgl_download).and_return({})
      allow(document).to receive(:iiif_download).and_return({})
      allow(document).to receive(:download_types).and_return(shapefile: {})
    end
    it 'renders the button group with primary and generated partials' do
      expect(view).to receive(:document_downloadable?).and_return(true)

      stub_template 'catalog/_downloads_primary.html.erb' => 'stubbed_primary_downloads'
      stub_template 'catalog/_downloads_generated.html.erb' => 'stubbed_generated_downloads'

      render

      expect(rendered).to have_content 'stubbed_primary_downloads'
      expect(rendered).to have_content 'stubbed_generated_downloads'
    end
  end
  context 'document is not downloadable' do
    let(:document) { instance_double(SolrDocument, restricted?: true, same_institution?: true) }
    before do
      expect(view).to receive(:document_downloadable?).and_return(false)
    end

    context 'when restricted & same institution' do
      it 'renders login link' do
        assign :document, document
        render
        expect(rendered).to have_css '.card-header a'
      end
    end
  end
end
