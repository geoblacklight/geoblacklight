require 'spec_helper'

feature 'Attribute table values', js: true do
  scenario 'are linkified' do
    visit solr_document_path 'minnesota-772ebcaf2ec0405ea1b156b5937593e7_0'
    # Wait until SVG elements are added
    expect(page).to have_css '.leaflet-overlay-pane svg'
    page.first('svg g path').click
    expect(page).to have_css 'td a[href="http://www.minneapolismn.gov/fire/stations/fire_station28"]', text: 'http://www.minneapolismn.gov/fire/stations/fire_station28'
  end
end
