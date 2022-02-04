# frozen_string_literal: true
require 'spec_helper'

feature 'tilejson layer' do
  scenario 'displays tilejson layer', js: true do
    visit solr_document_path('princeton-fk4544658v-tilejson')
    expect(page).to have_css '.leaflet-control-zoom', visible: :visible
    expect(page).to have_css "img[src*='https://map-tiles-staging.princeton.edu/mosaicjson/tiles/WebMercatorQuad']"
  end
end
