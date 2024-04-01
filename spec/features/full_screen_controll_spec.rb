# frozen_string_literal: true

require "spec_helper"

feature "Leaflet fullscreen control", js: true do
  scenario "IIIF layer should have full screen control" do
    visit solr_document_path("princeton-02870w62c")
    expect(page).to have_css(".leaflet-control-fullscreen-button")
  end

  scenario "WMS layer should have full screen control" do
    visit solr_document_path("stanford-cz128vq0535")
    expect(page).to have_css(".leaflet-control-fullscreen-button")
  end
end

feature "Clover IIIF fullscreen control", js: true do
  scenario "IIIF layer should have full screen control" do
    visit solr_document_path("princeton-sx61dn82p")
    expect(page).to have_button("Toggle full page")
  end
end
