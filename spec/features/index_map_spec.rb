# frozen_string_literal: true

require "spec_helper"

feature "Index map", js: true do
  # Colors
  default_color = "#7FCDBB"
  selected_color = "#2C7FB8"
  scenario "displays index map viewer (polygon)" do
    skip "Doesn't work for importmaps when headless in CI" if ENV["CI"]

    visit solr_document_path("stanford-fb897vt9938")
    # Wait until SVG elements are added
    expect(page).to have_css ".leaflet-overlay-pane svg"
    within "#leaflet-viewer" do
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
      # Click the top-left corner of the polygon instead of the center
      # to prevent it being occluded by other DOM elements (occurs in headless mode)
      find("svg g path:nth-child(2)").click(x: 1, y: 1)
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{selected_color}']"
      first("svg g path").click(x: 1, y: 1)
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
    end
  end

  scenario "displays index map viewer (points)" do
    skip "Doesn't work for importmaps when headless in CI" if ENV["CI"]

    visit solr_document_path("cornell-ny-aerial-photos-1960s")
    # Wait until SVG elements are added
    expect(page).to have_css ".leaflet-overlay-pane svg"
    within "#leaflet-viewer" do
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
      find("svg g path:nth-child(2)").click(x: 1, y: 1)
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{selected_color}']"
      first("svg g path").click(x: 1, y: 1)
      expect(page).to have_css "svg g path:nth-child(2)[fill='#{default_color}']"
    end
  end
end
