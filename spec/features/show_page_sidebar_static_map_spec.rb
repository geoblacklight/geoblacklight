# frozen_string_literal: true

require "spec_helper"

feature "Display sidebar static map on catalog#show page" do
  scenario "Document viewer protocol: IIIF (show)" do
    visit solr_document_path "princeton-02870w62c"
    within ".page-sidebar" do
      expect(page).to have_content "Location"
      expect(page).to have_css "div#static-map"
    end
  end

  scenario "Document viewer protocol: WMS (do not show)" do
    visit solr_document_path "stanford-cg357zz0321"
    within ".page-sidebar" do
      expect(page).to have_no_content "Location"
      expect(page).to have_no_css "div#static-map"
    end
  end
end
