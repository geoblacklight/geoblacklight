require 'spec_helper'

feature 'feature_layer reference', js: true do
  scenario 'displays image map layer' do
    visit solr_document_path 'princeton-test-oregon-naip-2011'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (all layers)' do
    visit solr_document_path 'minnesota-f14ff4-1359-4beb-b931-5cb41d20ab90'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (single layer)' do
    visit solr_document_path 'Minnesota-urn-0f7ae38b-4bf2-4e03-a32b-e87f245ccb03'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays feature layer' do
    pending 'cannot currently test for svg feature'
    visit solr_document_path 'minnesota-e2f33b52-4039-4bbb-9095-b5cdc0175943'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(Nokogiri::HTML.parse(page.body).css('g').length).to eq 23
    fail
  end
  scenario 'displays image map layer' do
    visit solr_document_path 'princeton-test-oregon-naip-2011'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays tiled map layer' do
    visit solr_document_path 'nyu-test-soil-survey-map'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-tile.leaflet-tile-loaded', visible: true
  end
  scenario 'displays Esri WMS layer' do
    visit solr_document_path 'purdue-urn-f082acb1-b01e-4a08-9126-fd62a23fd9aa'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-tile.leaflet-tile-loaded', visible: true
  end
end
