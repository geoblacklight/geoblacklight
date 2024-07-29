# frozen_string_literal: true

require "spec_helper"

feature "iiif reference" do
  scenario "displays leaflet viewer", js: true do
    visit solr_document_path("princeton-02870w62c")
    expect(page).to have_css '[data-button="zoom-in"]', visible: true
  end
end
