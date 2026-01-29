# frozen_string_literal: true

require "spec_helper"

feature "Leaflet fullscreen control", js: true do
  scenario "WMS layer should have full screen control" do
    visit solr_document_path("stanford-cz128vq0535")
    expect(page).to have_css(".leaflet-control-zoom-fullscreen")
  end
end

feature "IIIF fullscreen control", js: true do
  scenario "IIIF layer should have full screen control" do
    visit solr_document_path("princeton-sx61dn82p")
    expect(page).to have_button("Full screen")
  end

  scenario "IIIF image should have full screen control" do
    visit solr_document_path("princeton-02870w62c")
    expect(page).to have_css("img[alt='Toggle full page']")
  end
end
