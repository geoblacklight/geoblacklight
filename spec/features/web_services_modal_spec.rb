# frozen_string_literal: true

require "spec_helper"

feature "web services tools" do
  feature "when wms/wfs are provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "stanford-cg357zz0321"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "input", count: 4
        expect(page).to have_css "label", text: "Web Feature Service (WFS)"
        expect(page).to have_css 'input[value="https://geowebservices-restricted.stanford.edu/geoserver/wfs"]'
        expect(page).to have_css 'input[value="druid:cg357zz0321"]', count: 2
        expect(page).to have_css "label", text: "Web Mapping Service (WMS)"
        expect(page).to have_css 'input[value="https://geowebservices-restricted.stanford.edu/geoserver/wms"]'
      end
    end
  end
  feature "no wms or wfs provided" do
    scenario "does not show up in tools" do
      visit solr_document_path "mit-001145244"
      expect(page).not_to have_css "div.web-services-sidebar a", text: "Web services"
    end
  end
  feature "when xyz tile reference is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "6f47b103-9955-4bbe-a364-387039623106-xyz"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "XYZ Tiles"
        expect(page).to have_css 'input[value="https://earthquake.usgs.gov/basemap/tiles/faults/{z}/{x}/{y}.png"]'
      end
    end
  end
  feature "when wmts tile reference is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "princeton-fk4544658v-wmts"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "Web Map Tile Service"
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/mosaicjson/WMTSCapabilities.xml?id=2a91d82c541c426cb787cc62afe8f248"]'
      end
    end
  end
  feature "when tilejson reference is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "princeton-fk4544658v-tilejson"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "TileJSON Document"
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/mosaicjson/tilejson.json?id=2a91d82c541c426cb787cc62afe8f248"]'
      end
    end
  end
end
