# frozen_string_literal: true

require "spec_helper"

feature "tilejson layer" do
  before do
    WebMock.disable_net_connect!(allow_localhost: true, allow: "chromedriver.storage.googleapis.com")
  end

  after do
    WebMock.allow_net_connect!
  end

  scenario "displays tilejson layer", js: true do
    # Mock tilejson manifest url
    stub_request(:get, "https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json")
      .to_return(status: 200, body: read_fixture("manifests/tilejson.json"))

    visit solr_document_path("princeton-fk4544658v-tilejson")

    expect(page).to have_css ".leaflet-control-zoom", visible: :visible
    expect(page).to have_css "div[data-protocol='Tilejson']"
    expect(page).to have_css "div[data-url='https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json']"
  end
end
