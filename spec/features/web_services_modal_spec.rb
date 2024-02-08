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
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/WMTSCapabilities.xml"]'
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
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json"]'
      end
    end
  end
  feature "when a PMTiles reference is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "princeton-t722hd30j"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "PMTiles Layer"
        expect(page).to have_css 'input[value="https://geodata.lib.princeton.edu/fe/d2/80/fed28076eaa04506b7956f10f61a2f77/display_vector.pmtiles"]'
      end
    end
  end
  feature "when a COG reference is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "princeton-dc7h14b252v"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      within ".modal-body" do
        expect(page).to have_css "label", text: "COG Layer"
        expect(page).to have_css 'input[value="https://geodata.lib.princeton.edu/13/f5/58/13f5582c32a54be98fc2982077d0456e/display_raster.tif"]'
      end
    end
  end
  feature "copy to clipboard is provided", js: true do
    scenario "shows up in tools" do
      visit solr_document_path "princeton-dc7h14b252v"
      expect(page).to have_css "div.web-services-sidebar a", text: "Web services"
      click_link "Web services"
      expect(page).to have_text "Copy"
    end
  end
end
