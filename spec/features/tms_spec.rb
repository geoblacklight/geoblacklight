# frozen_string_literal: true

require "spec_helper"

feature "tms layer" do
  scenario "displays tms layer", js: true do
    visit solr_document_path("cugir-007957")
    expect(page).to have_css ".leaflet-control-zoom", visible: true
    expect(page).to have_css "img[src*='cugir.library.cornell.edu']"
  end
end
