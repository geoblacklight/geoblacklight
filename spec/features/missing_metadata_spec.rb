require 'spec_helper'

feature 'Missing metadata', js: true do
  scenario 'Yields error free results page for no spatial' do
    visit search_catalog_path(q: 'ASTER Global Emissivity')
    expect(page).to have_css('#map')
  end
  scenario 'Yields error free show page for no wxs_identifier or spatial' do
    visit solr_document_path('aster-global-emissivity-dataset-1-kilometer-v003-ag1kmcad20')
    expect(page).to have_css('#map')
  end
end
