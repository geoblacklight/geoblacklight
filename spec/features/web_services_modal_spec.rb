# frozen_string_literal: true

require "spec_helper"

# Open the web services modal and wait for it to load
def open_web_services_modal
  expect(page).to have_link "Web services"
  click_link "Web services"
  expect(page).to have_css "h1", text: "Web services"
end

describe "web services tools", type: :feature do
  context "when no linkable references provided" do
    it "does not show up in tools" do
      visit solr_document_path "mit-001145244"
      expect(page).not_to have_link "Web services"
    end
  end

  context "when any reference is linked" do
    it "shows copy to clipboard button" do
      visit solr_document_path "princeton-dc7h14b252v"
      open_web_services_modal
      expect(page).to have_text "Copy"
    end

    it "copies the link to clipboard", js: true do
      sign_in # NOTE: this seems to be required for clipboard permissions to be granted succesfully
      page.driver.browser.add_permission("clipboard-read", "granted")
      page.driver.browser.add_permission("clipboard-write", "granted")
      visit solr_document_path "princeton-1r66j405w"
      open_web_services_modal
      click_button "Copy"
      clip_text = page.evaluate_async_script("navigator.clipboard.readText().then(arguments[0])")
      expect(clip_text).to include("https://libimages1.princeton.edu/loris/figgy_prod/5a%2F20%2F58%2F5a20585db50d44959fe5ae44821fd174%2Fintermediate_file.jp2/info.json")
    end
  end

  context "when wms/wfs are provided" do
    it "shows up in tools" do
      visit solr_document_path "stanford-cg357zz0321"
      open_web_services_modal
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

  context "when xyz tile reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "6f47b103-9955-4bbe-a364-387039623106-xyz"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "XYZ Tiles"
        expect(page).to have_css 'input[value="https://earthquake.usgs.gov/basemap/tiles/faults/{z}/{x}/{y}.png"]'
      end
    end
  end

  context "when wmts tile reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-fk4544658v-wmts"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "Web Map Tile Service"
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/WMTSCapabilities.xml"]'
      end
    end
  end

  context "when tilejson reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-fk4544658v-tilejson"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "TileJSON Document"
        expect(page).to have_css 'input[value="https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json"]'
      end
    end
  end

  context "when a PMTiles reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-t722hd30j"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "PMTiles Layer"
        expect(page).to have_css 'input[value="https://geodata.lib.princeton.edu/fe/d2/80/fed28076eaa04506b7956f10f61a2f77/display_vector.pmtiles"]'
      end
    end
  end

  context "when a COG reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-dc7h14b252v"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "COG Layer"
        expect(page).to have_css 'input[value="https://geodata.lib.princeton.edu/13/f5/58/13f5582c32a54be98fc2982077d0456e/display_raster.tif"]'
      end
    end
  end
end
