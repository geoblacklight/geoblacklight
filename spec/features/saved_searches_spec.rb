require 'spec_helper'

feature 'saved searches' do
  scenario 'list spatial search', js: true do
    visit root_path
    find('#map').double_click
    within '#map' do
      find('a.search-control').click
      expect(page.current_url).to match /bbox=/
    end
    visit search_history_path
    expect(page).to have_css 'td.query a', text: /Bounding box:/
  end
end
