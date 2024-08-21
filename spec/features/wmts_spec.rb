# frozen_string_literal: true

require "spec_helper"

feature "wmts layer" do
  context "when referencing a WMTSCapabilities document" do
    scenario "displays the layer", js: true do
      visit solr_document_path("stanford-cz128vq0535-wmts")
      expect(page).to have_css ".leaflet-control-zoom", visible: :visible
      expect(page).to have_css "div[data-leaflet-viewer-protocol-value='Wmts']"
      expect(page).to have_css "div[data-leaflet-viewer-url-value='http://127.0.0.1:9000/geoserver/gwc/service/wmts?service=WMTS&version=1.1.1&request=GetCapabilities']"
    end
  end
end
