# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Home page", js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end

  scenario "map should be visible" do
    within "#main-container" do
      expect(page).to have_css("#leaflet-viewer")
      expect(page).to have_css("img.leaflet-tile", visible: :all)
    end
  end

  scenario "clicking map search should create a spatial search" do
    within "#leaflet-viewer" do
      find(".search-control a").click
      expect(page.current_url).to match(/bbox=/)
    end
    expect(page).to have_css "#documents"
  end
end
