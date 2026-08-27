# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Catalog index view", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  before do
    get search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
  end

  it "renders documents and the map container" do
    expect(response_page).to have_css("#documents")
    expect(response_page).to have_css(".document", count: 4)
    expect(response_page).to have_css("#overview-map")
  end

  it "gives the map an explicit description of the current results" do
    overview_results = JSON.parse(response_page.find("#documents")["data-overview-map-results"])
    rows = response_page.all(".document")

    expect(overview_results.pluck("id")).to eq rows.map { |row| row["data-map-id"] }
    expect(overview_results.pluck("place")).to eq rows.map { |row| row["data-document-counter"].to_i }
    expect(overview_results.pluck("geometry")).to all(include("type"))
  end

  it "gives the map the number shown beside each result, so both count the same way" do
    expect(response_page).to have_css(".document[data-document-counter]", count: 4)
    expect(response_page.all(".document").map { |result| result["data-document-counter"] })
      .to eq %w[1 2 3 4]
  end

  context "with a bounding box query" do
    before do
      get search_catalog_path(bbox: "-96 43 -92 46")
    end

    it "tells the map the area the results are filtered to" do
      expect(response_page.find("#overview-map")["search-bounds"]).to eq "-96 43 -92 46"
      expect(response_page.find("#overview-map-bounds", visible: :all)["data-bounds"]).to eq "-96 43 -92 46"
    end
  end

  it "renders sort and per-page controls" do
    expect(response_page).to have_css("#sort-dropdown")
    expect(response_page).to have_css("#per_page-dropdown")
  end

  it "renders schema.org properties" do
    expect(response_page.first(".documentHeader")).to have_css("a[itemprop='name']")
    expect(response_page).to have_css(".metadata [itemprop='description']")
  end

  it "renders a truncated description alongside the badges for results that have one" do
    expect(response_page).to have_css(".metadata .badges")
    expect(response_page).to have_css(".metadata .description")
  end
end
