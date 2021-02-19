# frozen_string_literal: true
require 'spec_helper'

feature 'wmts layer' do
  scenario 'displays wmts layer', js: true do
    visit solr_document_path('0a1891cc-2125-48cf-b504-8fb900c2bd95')
    expect(page).to have_css '.leaflet-control-zoom', visible: true
    expect(page).to have_css "img[src*='realearth.ssec.wisc.edu']"
  end
end
