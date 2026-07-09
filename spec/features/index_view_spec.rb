# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Index view", js: true do
  let(:subject_field) { Geoblacklight.configuration.fields.subject }
  before do
    visit search_catalog_path(q: "*")
  end

  scenario "should have documents and map on page" do
    visit search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
    expect(page).to have_css("#documents")
    expect(page).to have_css(".document", count: 5)
    expect(page).to have_css("#leaflet-viewer")
  end

  scenario "should have sort and per_page on page" do
    visit search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
    expect(page).to have_css("#sort-dropdown")
    expect(page).to have_css("#per_page-dropdown")
  end

  scenario "hover on record should produce bounding box on map" do
    # Needed to find an svg element on the page
    visit search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
    # BL7 has svg icons, so sniffing for SVG path won't return false
    # expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 0
    find(".documentHeader", match: :first).hover
    within("#leaflet-viewer") do
      expect(page).to have_css("path")
    end
  end

  scenario "click on a record area to expand collapse" do
    within("article", match: :first) do
      expect(page).to have_css(".collapsed")
      find("button").click
      expect(page).not_to have_css(".collapsed")
    end
  end

  scenario "clicking map search should retain current search parameters" do
    visit "/?f[#{subject_field}][]=Population"
    find("#leaflet-viewer").double_click
    within "#appliedParams" do
      expect(page).to have_content("Subject Population")
    end
  end

  scenario "should have schema.org props listed" do
    visit search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
    within(".documentHeader", match: :first) do
      expect(page).to have_css("a[itemprop='name']")
      find(".dropdown-toggle").click
    end
    within(".more-info-area", match: :first) do
      expect(page).to have_css("small[itemprop='description']")
    end
  end
end
