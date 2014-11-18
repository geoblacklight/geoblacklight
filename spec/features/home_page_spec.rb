require 'spec_helper'

feature 'Home page', js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end
  scenario 'search bar' do
    expect(page).to_not have_css '#search-navbar'
    within '.jumbotron' do
      expect(page).to have_css 'h2', text: 'Explore and discover...'
      expect(page).to have_css 'h3', text: 'Find the maps and data you need'
      expect(page).to have_css 'form.search-query-form'
    end
  end
  scenario 'find by category' do
    expect(page).to have_css '.home-facet-label', count: 7
    click_link 'Census'
    expect(page).to have_css '.filterName', text: 'Subject'
    expect(page).to have_css '.filterValue', text: 'Census'
  end
  scenario 'map should be visible' do
    within '#main-container' do
      expect(page).to have_css('#map')
      expect(page).to have_css('img.leaflet-tile', count: 4)
    end
  end
  scenario 'clicking map search should create a spatial search' do
    find('#map').double_click
    within '#map' do
      find('a.search-control').click
      expect(page.current_url).to match /bbox=/
    end
    expect(page).to have_css '#documents'
  end
end
