require 'spec_helper'

feature 'Layer preview', js: true do
  scenario 'Restricted layer should show bounding box' do
    visit solr_document_path('stanford-cg357zz0321')
    within('#map') do
      expect(page).to have_css('path')
    end
  end

  scenario 'Public layer should show wms layer not bounding box' do
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    # BL7 has svg icons, so sniffing for SVG path won't return false
    # expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 0
    within '.leaflet-tile-pane' do
      expect(page).to have_css('.leaflet-layer', count: 2)
    end
  end
end
