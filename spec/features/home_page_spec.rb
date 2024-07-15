# frozen_string_literal: true

require "spec_helper"

feature "Home page", js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end
  scenario "navbar" do
    expect(page).to have_css "#bookmarks_nav"
    expect(page).to have_css "a", text: "History"
  end
  scenario "search bar" do
    expect(page).not_to have_css "#search-navbar"
    within ".jumbotron" do
      expect(page).to have_css "h1", text: "Explore and discover..."
      expect(page).to have_css "h2", text: "Find the maps and data you need"
      expect(page).to have_css "form.search-query-form"
    end
  end
  scenario "find by category" do
    expect(page).to have_css ".category-block", count: 4
    expect(page).to have_css ".home-facet-link", count: 36
    expect(page).to have_css "a.more_facets_link", count: 4
    click_link "Counties"
    expect(page).to have_css ".filter-name", text: "Subject"
    expect(page).to have_css ".filter-value", text: "Counties"
  end
  scenario "map should be visible" do
    within "#main-container" do
      expect(page).to have_css("#leaflet-viewer")
      expect(page).to have_css("img.leaflet-tile", minimum: 3)
    end
  end
  scenario "clicking map search should create a spatial search" do
    within "#leaflet-viewer" do
      find(".search-control a").click
      expect(page.current_url).to match(/bbox=/)
    end
    expect(page).to have_css "#documents"
  end
  scenario "can search by placename" do
    click_link "New York, New York"
    results = page.all(:css, "article.document")
    expect(results.count).to equal(4)
  end
  scenario "pages should have meta tag with geoblacklight version" do
    expect(page.body).to include("geoblacklight-version")
  end
end
