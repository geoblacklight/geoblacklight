require 'spec_helper'

feature 'Attribute table values', js: true do
  scenario 'are linkified' do
    visit solr_document_path 'minnesota-e2f33b52-4039-4bbb-9095-b5cdc0175943'
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    page.first('svg g path').click
    expect(page).to have_css 'td a[href="http://www.minneapolismn.gov/fire/stations/fire_station28"]', text: 'http://www.minneapolismn.gov/fire/stations/fire_station28'
  end
end
