require 'spec_helper'

feature 'Home page', js: true do # use js: true for tests which require js, but it slows things down
  before do
    visit root_path
  end
  scenario 'should have facets listed correctly' do
    within '#facet-panel-collapse' do
      expect(page).to have_css('div.panel.facet_limit', text: 'Institution')
      expect(page).to have_css('div.panel.facet_limit', text: 'Publisher')
      expect(page).to have_css('div.panel.facet_limit', text: 'Subject')
      expect(page).to have_css('div.panel.facet_limit', text: 'Place')
      expect(page).to have_css('div.panel.facet_limit', text: 'Year')
      expect(page).to have_css('div.panel.facet_limit', text: 'Access')
      expect(page).to have_css('div.panel.facet_limit', text: 'Data type')
      expect(page).to have_css('div.panel.facet_limit', text: 'Format')
      expect(page).to have_css('div.panel.facet_limit', text: 'Language')
    end
    click_link 'Institution'
    expect(page).to have_css('a.facet_select', text: 'Harvard', visible: true)
    expect(page).to have_css('a.facet_select', text: 'Tufts', visible: true)
    expect(page).to have_css('a.facet_select', text: 'MIT', visible: true)
    expect(page).to have_css('a.facet_select', text: 'MassGIS', visible: true)
    expect(page).to have_css('a.facet_select', text: 'Stanford', visible: true)
  end
  scenario 'map should be visible' do
    within '#geoblacklight-map-home' do
      expect(page).to have_css('#map')
      expect(page).to have_css('img.leaflet-tile', count: 8)
    end
  end

end
