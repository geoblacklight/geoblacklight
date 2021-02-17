# frozen_string_literal: true
require 'spec_helper'

feature 'Blacklight Bookmarks' do
  scenario 'index has created bookmarks' do
    visit solr_document_path 'nyu-2451-34564'
    click_button 'Bookmark'
    visit bookmarks_path
    expect(page).to have_css '.document', count: 1

    # The JS selector to initiate a leaflet map should not be present
    expect(page).not_to have_css 'body.blacklight-catalog [data-map="index"]'
  end
end
