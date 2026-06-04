# frozen_string_literal: true

require "spec_helper"

feature "tilejson layer" do
  scenario "displays tilejson layer", js: true do
    # Mock tilejson manifest url
    proxy.stub("https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json")
      .and_return(status: 200, body: read_fixture("manifests/tilejson.json"))

    visit solr_document_path("princeton-fk4544658v-tilejson")

    expect(page).to have_css ".leaflet-control-zoom", visible: :visible
    expect(page).to have_css "div[data-leaflet-viewer-protocol-value='Tilejson']"
    expect(page).to have_css "div[data-leaflet-viewer-url-value='https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json']"
  end
end
