# frozen_string_literal: true
require 'spec_helper'

feature 'Attribute table values', js: true do
  xscenario 'are linkified' do
    # ArcGIS server returning an error. Wait until SVG elements are added
    visit solr_document_path 'f406332e63eb4478a9560ad86ae90327_18'
    expect(page).to have_css '.leaflet-overlay-pane svg'
    page.first('svg g path').click
    expect(page).to have_css 'td a[href="http://www.minneapolismn.gov/fire/stations/fire_station28"]', text: 'http://www.minneapolismn.gov/fire/stations/fire_station28'
  end
end
