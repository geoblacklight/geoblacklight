require 'spec_helper'

feature 'esrimapservice reference' do
  scenario 'displays leaflet viewer', js: true do
    visit catalog_path('minnesota-park')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
  end
end
