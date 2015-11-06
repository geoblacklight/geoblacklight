require 'spec_helper'

feature 'Layer opacity', js: true do
  scenario 'WMS layer should have opacity control' do
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('div.opacity-text', text: '75%')
    expect(page.all('div.leaflet-layer')[1][:style]).to eq('opacity: 0.75; ')
  end
end
