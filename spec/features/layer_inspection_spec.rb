# frozen_string_literal: true

require "spec_helper"

feature "Layer inspection", js: true do
  scenario "clicking map should trigger inspection" do
    visit solr_document_path("nyu-2451-34564")
    expect(page).to have_css("th", text: "Attribute")
    find("#leaflet-viewer").click
    expect(page).not_to have_css("td.default-text")
  end
end
