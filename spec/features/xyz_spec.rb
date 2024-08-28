# frozen_string_literal: true

require "spec_helper"

feature "xyz layer" do
  scenario "displays tms layer", js: true do
    visit solr_document_path("6f47b103-9955-4bbe-a364-387039623106-xyz")
    expect(page).to have_css ".leaflet-control-zoom", visible: :visible
    expect(page).to have_css "img.leaflet-tile-loaded[src*='earthquake.usgs.gov']"
  end
end
