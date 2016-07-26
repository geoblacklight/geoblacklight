require 'spec_helper'

feature 'feature_layer reference', js: true do
  scenario 'displays image map layer' do
    visit solr_document_path 'minnesota-test-oregon-naip-2011'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (all layers)' do
    visit solr_document_path 'illinois-f14ff4-1359-4beb-b931-5cb41d20ab90'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (single layer)' do
    visit solr_document_path 'maryland-fc5cd2-732d-4559-a9c7-df38dd683aec'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays feature layer' do
    pending 'cannot currently test for svg feature'
    visit solr_document_path 'minnesota-772ebcaf2ec0405ea1b156b5937593e7_0'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(Nokogiri::HTML.parse(page.body).css('g').length).to eq 23
    fail
  end
  scenario 'displays image map layer' do
    visit solr_document_path 'minnesota-test-oregon-naip-2011'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays tiled map layer' do
    visit solr_document_path 'minnesota-test-soil-survey-map'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-tile.leaflet-tile-loaded', visible: true
  end
  scenario 'displays Esri WMS layer' do
    visit solr_document_path 'psu-32ef9f-0762-445c-8250-f4a5e220a46d'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-tile.leaflet-tile-loaded', visible: true
  end
end
