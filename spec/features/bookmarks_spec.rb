require 'spec_helper'

feature 'Blacklight Bookmarks' do
  scenario 'index has created bookmarks' do
    visit solr_document_path 'columbia-columbia-landinfo-global-aet'
    click_button 'Bookmark'
    visit bookmarks_path
    expect(page).to have_css '.document', count: 1
  end
end
