require 'spec_helper'

feature 'feature_layer reference' do
  scenario 'displays leaflet viewer', js: true do
    visit catalog_path('minnesota-test-neighborhoods-pdx')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
  end
end
