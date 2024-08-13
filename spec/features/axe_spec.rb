# frozen_string_literal: true

require "axe-rspec"
require "spec_helper"

feature "Accessibility testing", js: true do
  context "logged out tests" do
    it "validates the home page" do
      visit root_path
      expect(page).to be_accessible
    end

    it "validates an item page" do
      visit solr_document_path("tufts-cambridgegrid100-04")
      expect(page).to be_accessible
    end

    it "validates an item page with relationships" do
      visit solr_document_path("all-relationships")
      sleep 0.5 # wait for relationships to be fully visible / faded in
      expect(page).to be_accessible
    end

    it "validates an bookmarks page" do
      visit solr_document_path("tufts-cambridgegrid100-04")
      find(".checkbox.toggle-bookmark").click
      visit bookmarks_path
      expect(page).to be_accessible
    end

    it "validates the history page" do
      visit "/search_history"
      expect(page).to be_accessible
      visit search_catalog_path({q: "index"})
      visit "/search_history"
      expect(page).to be_accessible
    end
  end

  context "logged in tests" do
    before do
      sign_in
    end

    it "validates the home page" do
      visit root_path
      expect(page).to be_accessible
    end

    it "validates an item page" do
      visit solr_document_path("princeton-1r66j405w")
      expect(page).to be_accessible
    end

    it "validates an bookmarks page" do
      visit solr_document_path("all-relationships")
      find(".checkbox.toggle-bookmark").click
      visit "/bookmarks"
      expect(page).to be_accessible
    end
  end

  def be_accessible
    be_axe_clean.excluding("#clover-viewer")
  end
end
