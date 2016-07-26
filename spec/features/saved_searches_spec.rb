require 'spec_helper'

feature 'saved searches' do
  scenario 'list spatial search', js: true do
    visit root_path
    within '#map' do
      find('.search-control a').click
      expect(page.current_url).to match(/bbox=/)
    end
    visit blacklight.search_history_path
    expect(page).to have_css 'td.query a', text: /Bounding box:/
  end
end
