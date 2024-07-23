# frozen_string_literal: true

require "spec_helper"

feature "Missing metadata", js: true do
  scenario "Yields error free results page for no spatial" do
    visit search_catalog_path(q: "ASTER Global Emissivity")
    expect(page).to have_css("#leaflet-viewer")
  end
  scenario "Yields error free show page for no wxs_identifier or spatial" do
    visit solr_document_path("aster-global-emissivity-dataset-1-kilometer-v003-ag1kmcad20")
    expect(page).to have_css("#leaflet-viewer")
  end
  scenario "Yields error free show page for no layer_geom_type_s" do
    visit solr_document_path("05d-03-noGeomType")
    expect(page).to have_css("#leaflet-viewer")
  end
  scenario "Yields error free show page for no dct_provider_s" do
    visit solr_document_path("99-0001-noprovider")
    expect(page).to have_css("#leaflet-viewer")
  end
  scenario "Yields error free show page for no locn_geometry" do
    visit solr_document_path("05d-p16022coll246-noGeo")
    expect(page).to have_css("#leaflet-viewer")
  end
end
