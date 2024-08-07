# frozen_string_literal: true

require "spec_helper"

feature "Oembed layer" do
  scenario "Should show oembed content and map" do
    visit solr_document_path("stanford-dc482zx1528")
    expect(page).to have_css "#oembed-viewer"
    expect(page).to have_css '[data-controller="oembed-viewer"]'
  end
end
