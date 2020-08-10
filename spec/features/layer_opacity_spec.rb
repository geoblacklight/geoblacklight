# frozen_string_literal: true
require 'spec_helper'

feature 'Layer opacity', js: true do
  scenario 'WMS layer should have opacity control' do
    visit solr_document_path('mit-f6rqs4ucovjk2')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.all('div.leaflet-layer')[1][:style]).to match(/opacity: 0.75;/)
  end

  scenario 'ESRI image service layer should have opacity control' do
    visit solr_document_path('32653ed6-8d83-4692-8a06-bf13ffe2c018')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.find('img.leaflet-image-layer', match: :first)[:style]).to match(/opacity: 0.75;/)
  end

  scenario 'IIIF layer should not have opacity control' do
    visit solr_document_path('princeton-02870w62c')
    expect(page).not_to have_css('div.opacity-text', text: '75%')
  end
end
