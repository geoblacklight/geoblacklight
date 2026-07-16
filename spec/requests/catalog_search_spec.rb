# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Catalog search", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  it "accepts an empty search" do
    get root_path(q: "", search_field: "all_fields")

    expect(response).to have_http_status(:ok)
    expect(response_page).to have_css("#documents")
  end

  it "renders the search bar for a spatial search" do
    get search_catalog_path(bbox: "25 3 75 35")

    expect(response_page).to have_css(".navbar-search")
  end

  it "renders the search bar for a text search" do
    get search_catalog_path(q: "test")

    expect(response_page).to have_css(".navbar-search")
  end

  it "hides suppressed records from ordinary search results" do
    get search_catalog_path(q: "Sanborn Map Company")

    expect(response_page).to have_css(".document", count: 1)
  end

  it "sorts the highest index year first and missing years last" do
    get search_catalog_path(
      f: {Geoblacklight.configuration.fields.provider => ["University of Minnesota"]},
      sort: "gbl_indexYear_im desc, dct_title_sort asc"
    )

    documents = response_page.all(".document")
    expect(documents.first["data-document-id"]).to eq("02236876-9c21-42f6-9870-d2562da8e44f")
    expect(documents.last["data-document-id"]).to eq("05d-03-nogeomtype")
  end
end
