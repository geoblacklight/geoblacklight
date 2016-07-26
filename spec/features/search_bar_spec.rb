require 'spec_helper'

feature 'search bar' do
  scenario 'present on a spatial search' do
    visit search_catalog_path(bbox: '25 3 75 35')
    expect(page).to have_css '#search-navbar'
  end
  scenario 'present on a text search' do
    visit search_catalog_path(q: 'test')
    expect(page).to have_css '#search-navbar'
  end
end
