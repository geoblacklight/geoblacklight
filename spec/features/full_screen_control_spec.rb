# frozen_string_literal: true

require "spec_helper"

feature "Leaflet fullscreen control", js: true do
  scenario "WMS layer should have full screen control" do
    visit solr_document_path("stanford-cz128vq0535")
    expect(page).to have_css(".leaflet-control-fullscreen-button", visible: :all)
  end
end

feature "Clover IIIF fullscreen control", js: true do
  scenario "IIIF layer should have full screen control" do
    skip "Clover is disabled" # see https://github.com/geoblacklight/geoblacklight/issues/1675
    visit solr_document_path("princeton-sx61dn82p")
    expect(page).to have_button("Toggle full page")
  end

  scenario "IIIF image should have full screen control" do
    skip "Clover is disabled" # see https://github.com/geoblacklight/geoblacklight/issues/1675
    visit solr_document_path("princeton-02870w62c")
    expect(page).to have_css("[data-button='full-page']")
  end
end
