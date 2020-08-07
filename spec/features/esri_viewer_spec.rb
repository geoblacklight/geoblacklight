# frozen_string_literal: true
require 'spec_helper'

feature 'feature_layer reference', js: true do
  scenario 'displays image map layer' do
    visit solr_document_path '32653ed6-8d83-4692-8a06-bf13ffe2c018'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (all layers)' do
    pending 'external service disabled cors access'
    visit solr_document_path '90f14ff4-1359-4beb-b931-5cb41d20ab90'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays dynamic layer (single layer)' do
    visit solr_document_path '4669301e-b4b2-4c8b-bf40-01b968a2865b'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css 'img.leaflet-image-layer', visible: true
  end
  scenario 'displays feature layer' do
    pending 'cannot currently test for svg feature'
    visit solr_document_path 'f406332e63eb4478a9560ad86ae90327_18'
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(Nokogiri::HTML.parse(page.body).css('g').length).to eq 23
    fail
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
