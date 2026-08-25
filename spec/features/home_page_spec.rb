# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Home page", js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end

  scenario "map should be visible" do
    within "#main-container" do
      expect(page).to have_css("#overview-map")
    end

    # The map itself is drawn inside the element
    expect(find("#overview-map").shadow_root).to have_css("canvas.maplibregl-canvas")
  end

  scenario "dragging a box over the map should create a spatial search" do
    search_map_area

    expect(page).to have_current_path(/bbox=/, url: true, wait: 10)
    expect(page).to have_css "#documents"
  end
end
