# frozen_string_literal: true

require "spec_helper"

feature "Layer inspection", js: true do
  scenario "clicking map should trigger inspection" do
    visit solr_document_path("tufts-cambridgegrid100-04")
    expect(page).to have_css("th", text: "Attribute")
    find("#leaflet-viewer").click
    expect(page).not_to have_css("td.default-text")
  end

  context "with a pmtiles layer" do
    scenario "clicking map should trigger inspection" do
      skip "FIXME: Only works with a headful browser?"
      visit solr_document_path("princeton-t722hd30j")
      expect(page).to have_css("th", text: "Attribute")
      find("#openlayers-viewer").click
      expect(page).not_to have_css("td.default-text")
    end
  end
end
