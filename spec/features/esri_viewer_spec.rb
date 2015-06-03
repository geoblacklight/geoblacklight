require 'spec_helper'

feature 'esrimapservice reference' do
  scenario 'displays leaflet viewer', js: true do
    visit catalog_path('minnesota-test-soil-survey-map')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
  end
end
