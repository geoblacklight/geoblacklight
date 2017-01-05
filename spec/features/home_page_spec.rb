require 'spec_helper'

feature 'Home page', js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end
  scenario 'search bar' do
    expect(page).not_to have_css '#search-navbar'
    within '.jumbotron' do
      expect(page).to have_css 'h2', text: 'Explore and discover...'
      expect(page).to have_css 'h3', text: 'Find the maps and data you need'
      expect(page).to have_css 'form.search-query-form'
    end
  end
  scenario 'find by category' do
    expect(page).to have_css '.category-block', count: 4
    expect(page).to have_css '.home-facet-link', count: 34
    expect(page).to have_css 'a.more_facets_link', count: 4
    click_link 'Elevation'
    expect(page).to have_css '.filterName', text: 'Subject'
    expect(page).to have_css '.filterValue', text: 'Elevation'
  end
  scenario 'map should be visible' do
    within '#main-container' do
      expect(page).to have_css('#map')
      expect(page).to have_css('img.leaflet-tile', minimum: 3)
    end
  end
  scenario 'clicking map search should create a spatial search' do
    within '#map' do
      find('.search-control a').click
      expect(page.current_url).to match(/bbox=/)
    end
    expect(page).to have_css '#documents'
  end
end
