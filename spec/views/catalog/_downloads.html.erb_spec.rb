require 'spec_helper'

describe 'catalog/_downloads.html.erb', type: :view do
  context 'document is downloadable' do
    it 'renders the button group with primary and secondary partials' do
      expect(view).to receive(:document_downloadable?).and_return(true)
      stub_template 'catalog/_downloads_primary.html.erb' => 'stubbed_primary_downloads'
      stub_template 'catalog/_downloads_secondary.html.erb' => 'stubbed_secondary_downloads'
      render
      expect(rendered).to have_css '.btn-group'
      expect(rendered).to have_content 'stubbed_primary_downloads'
      expect(rendered).to have_content 'stubbed_secondary_downloads'
    end
  end
  context 'document is not downloadable' do
    let(:document) { double('document', restricted?: true, same_institution?: true) }
    before(:each) do
      expect(view).to receive(:document_downloadable?).and_return(false)
    end

    context 'when restricted & same institution' do
      it 'renders login link' do
        assign :document, document
        render
        expect(rendered).to have_css '.panel-body a'
      end
    end
  end
end
