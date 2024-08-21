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
      visit solr_document_path "stanford-cz128vq0535-wmts"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "Web Map Tile Service"
        expect(page).to have_css 'input[value="http://127.0.0.1:9000/geoserver/gwc/service/wmts?service=WMTS&version=1.1.1&request=GetCapabilities"]'
      end
    end
  end

  context "when tilejson reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "stanford-cz128vq0535-tilejson"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "TileJSON Document"
        expect(page).to have_css 'input[value="http://127.0.0.1:9002/data/stanford-cz128vq0535-tilejson/tilejson.json"]'
      end
    end
  end

  context "when a PMTiles reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-t722hd30j"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "PMTiles Layer"
        expect(page).to have_css 'input[value="http://127.0.0.1:9002/data/princeton-t722hd30j/princeton-t722hd30j.pmtiles"]'
      end
    end
  end

  context "when a COG reference is provided" do
    it "shows up in tools" do
      visit solr_document_path "princeton-dc7h14b252v"
      open_web_services_modal
      within ".modal-body" do
        expect(page).to have_css "label", text: "COG Layer"
        expect(page).to have_css 'input[value="http://127.0.0.1:9002/data/princeton-dc7h14b252v/princeton-dc7h14b252v.tif"]'
      end
    end
  end
end
