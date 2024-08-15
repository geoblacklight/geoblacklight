# frozen_string_literal: true

require "spec_helper"

feature "Blacklight Bookmarks" do
  scenario "index has created bookmarks" do
    visit solr_document_path "harvard-g7064-s2-1834-k3"
    click_button "Bookmark"
    visit bookmarks_path
    expect(page).to have_css ".document", count: 1
  end
end
