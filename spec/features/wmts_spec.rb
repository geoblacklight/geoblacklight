# frozen_string_literal: true
require 'spec_helper'

feature 'wmts layer' do
  context 'when referencing a WMTSCapabilities document with a single layer' do
    scenario 'displays the layer', js: true do
      visit solr_document_path('princeton-fk4544658v-wmts')
      expect(page).to have_css '.leaflet-control-zoom', visible: :visible
      expect(page).to have_css "img[src*='map-tiles-staging.princeton.edu/mosaicjson/tiles/WebMercatorQuad']"
    end
  end
  context 'when referencing a WMTSCapabilities document with a multiple layers' do
    scenario 'displays the layer referenced in the layer_id field', js: true do
      visit solr_document_path('princeton-fk4db9hn29')
      expect(page).to have_css '.leaflet-control-zoom', visible: :visible
      expect(page).to have_css "img[src*='http://maps1.wien.gv.at/wmts/lb2016/farbe/google3857']"
    end
  end
end
