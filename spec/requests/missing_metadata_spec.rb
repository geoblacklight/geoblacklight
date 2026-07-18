# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Records with missing metadata", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "renders search results when spatial metadata is absent" do
    get search_catalog_path(q: "ASTER Global Emissivity")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("#leaflet-viewer")
  end

  {
    "aster-global-emissivity-dataset-1-kilometer-v003-ag1kmcad20" => "WXS identifier and spatial metadata",
    "05d-03-noGeomType" => "geometry type",
    "99-0001-noprovider" => "provider",
    "05d-p16022coll246-noGeo" => "geometry"
  }.each do |document_id, missing_value|
    it "renders a show page without #{missing_value}" do
      get solr_document_path(document_id)

      expect(response).to have_http_status(:ok)
      expect(response_page).to have_css("dl.document-metadata")
    end
  end
end
