# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Records with missing metadata", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "renders search results when spatial metadata is absent" do
    get search_catalog_path(q: "Ames Library of South Asia Maps")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("#overview-map")
  end

  it "renders a show page when spatial metadata is absent" do
    get solr_document_path("05d-p16022coll246-noGeo")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("dl.document-metadata")
  end

  it "renders a show page when there is no provider set" do
    get solr_document_path("99-0001-noprovider")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("dl.document-metadata")
  end
end
