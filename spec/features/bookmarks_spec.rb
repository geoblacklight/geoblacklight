# frozen_string_literal: true

require "spec_helper"

feature "Blacklight Bookmarks" do
  scenario "index has created bookmarks" do
    visit solr_document_path "nyu-2451-34564"
    click_button "Bookmark"
    visit bookmarks_path
    sleep(2)
    expect(page).to have_css ".document", count: 1
  end
end
