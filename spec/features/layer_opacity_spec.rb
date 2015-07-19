require 'spec_helper'

feature 'Layer opacity', js: true do
  scenario 'WMS layer should have opacity control' do
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.all('div.leaflet-layer')[1][:style]).to eq('opacity: 0.75; ')
  end

  scenario 'ESRI feature layer should have opacity control' do
    visit catalog_path('minnesota-test-neighborhoods-pdx')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page).to have_selector('path.leaflet-clickable', count: 220)
    expect(page.find('path.leaflet-clickable', match: :first)[:style]).to eq('opacity: 0.75; ')
  end
end
