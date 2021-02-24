# frozen_string_literal: true
require 'spec_helper'

feature 'tms layer' do
  scenario 'displays tms layer', js: true do
    visit solr_document_path('6f47b103-9955-4bbe-a364-387039623106')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css "img[src*='earthquake.usgs.gov']"
  end
end
