# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Catalog index view", type: :request do
  let(:response_page) { Capybara.string(response.body) }

  before do
    get search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
  end

  it "renders documents and the map container" do
    expect(response_page).to have_css("#documents")
    expect(response_page).to have_css(".document", count: 5)
    expect(response_page).to have_css("#leaflet-viewer")
  end

  it "renders sort and per-page controls" do
    expect(response_page).to have_css("#sort-dropdown")
    expect(response_page).to have_css("#per_page-dropdown")
  end

  it "renders schema.org properties" do
    expect(response_page.first(".documentHeader")).to have_css("a[itemprop='name']")
    expect(response_page.first(".more-info-area")).to have_css("small[itemprop='description']")
  end
end
