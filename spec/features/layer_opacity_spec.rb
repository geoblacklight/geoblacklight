require 'spec_helper'

feature 'Layer opacity', js: true do
  scenario 'WMS layer should have opacity control' do
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.all('div.leaflet-layer')[1][:style]).to match(/opacity: 0.75;/)
  end

  scenario 'ESRI image service layer should have opacity control' do
    visit solr_document_path('minnesota-test-oregon-naip-2011')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.find('img.leaflet-image-layer', match: :first)[:style]).to match(/opacity: 0.75;/)
  end

  scenario 'IIIF layer should not have opacity control' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).not_to have_css('div.opacity-text', text: '75%')
  end
end
