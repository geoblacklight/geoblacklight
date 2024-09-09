# frozen_string_literal: true

require "spec_helper"

feature "tilejson layer" do
  scenario "displays tilejson layer", js: true do
    visit solr_document_path("stanford-cz128vq0535-tilejson")

    expect(page).to have_css ".leaflet-control-zoom", visible: :visible
    expect(page).to have_css "div[data-leaflet-viewer-protocol-value='Tilejson']"
    expect(page).to have_css "div[data-leaflet-viewer-url-value='http://127.0.0.1:9002/data/stanford-cz128vq0535-tilejson/tilejson.json']"
    expect(page).to have_css "img.leaflet-tile-loaded[src*='127.0.0.1:9000/geoserver/']"
  end
end
