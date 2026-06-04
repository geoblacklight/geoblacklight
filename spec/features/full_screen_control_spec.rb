# frozen_string_literal: true

require "spec_helper"

feature "IIIF fullscreen control", js: true do
  scenario "IIIF layer should have full screen control" do
    visit solr_document_path("princeton-sx61dn82p")
    expect(page).to have_button("Full screen")
  end

  scenario "IIIF image should have full screen control" do
    visit solr_document_path("princeton-02870w62c")
    expect(page).to have_css("img[alt='Toggle full page']")
  end
end
