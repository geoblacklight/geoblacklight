require 'spec_helper'

feature 'iiif reference' do
  scenario 'displays leaflet viewer', js: true do
    visit solr_document_path('princeton-02870w62c')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
  end
end
