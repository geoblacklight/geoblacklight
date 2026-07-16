# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Web services", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "omits the tool when no linkable references are present" do
    get solr_document_path("mit-001145244")

    expect(response_page).to have_no_link("Web services")
  end

  it "renders a copy control for a linked reference" do
    get web_services_solr_document_path("princeton-dc7h14b252v")

    expect(response_page).to have_text("Copy")
  end

  it "allows a suppressed record's web services to be viewed" do
    get web_services_solr_document_path("princeton-jq085m62x")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("h1.modal-title", text: "Web services")
  end

  it "renders WMS and WFS service values" do
    get web_services_solr_document_path("stanford-cg357zz0321")

    expect(response_page).to have_css("label", text: "Web Feature Service (WFS)", visible: :all)
    expect(response_page).to have_css('input[value="https://geowebservices-restricted.stanford.edu/geoserver/wfs"]', visible: :all)
    expect(response_page).to have_css('input[value="druid:cg357zz0321"]', count: 2, visible: :all)
    expect(response_page).to have_css("label", text: "Web Mapping Service (WMS)", visible: :all)
    expect(response_page).to have_css('input[value="https://geowebservices-restricted.stanford.edu/geoserver/wms"]', visible: :all)
  end

  {
    "6f47b103-9955-4bbe-a364-387039623106-xyz" => ["XYZ Tiles", "https://earthquake.usgs.gov/basemap/tiles/faults/{z}/{x}/{y}.png"],
    "princeton-fk4544658v-wmts" => ["Web Map Tile Service", "https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/WMTSCapabilities.xml"],
    "princeton-fk4544658v-tilejson" => ["TileJSON Document", "https://map-tiles-staging.princeton.edu/2a91d82c541c426cb787cc62afe8f248/mosaicjson/tilejson.json"],
    "princeton-t722hd30j" => ["PMTiles Layer", "https://geodata.lib.princeton.edu/fe/d2/80/fed28076eaa04506b7956f10f61a2f77/display_vector.pmtiles"],
    "princeton-dc7h14b252v" => ["COG Layer", "https://geodata.lib.princeton.edu/13/f5/58/13f5582c32a54be98fc2982077d0456e/display_raster.tif"]
  }.each do |document_id, (label, value)|
    it "renders the #{label} service value" do
      get web_services_solr_document_path(document_id)

      expect(response_page).to have_css("label", text: label, visible: :all)
      expect(response_page).to have_css("input[value='#{value}']", visible: :all)
    end
  end
end
