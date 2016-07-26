require 'spec_helper'

feature 'web services tools' do
  feature 'when wms/wfs are provided', js: true do
    scenario 'shows up in tools' do
      visit solr_document_path 'stanford-cg357zz0321'
      expect(page).to have_css 'li.web_services a', text: 'Web services'
      click_link 'Web services'
      within '.modal-body' do
        expect(page).to have_css 'input', count: 4
        expect(page).to have_css 'label', text: 'Web Feature Service (WFS)'
        expect(page).to have_css 'input[value="http://geowebservices-restricted.stanford.edu/geoserver/wfs"]'
        expect(page).to have_css 'label', text: 'WFS typeNames'
        expect(page).to have_css 'input[value="druid:cg357zz0321"]', count: 2
        expect(page).to have_css 'label', text: 'Web Mapping Service (WMS)'
        expect(page).to have_css 'input[value="http://geowebservices-restricted.stanford.edu/geoserver/wms"]'
        expect(page).to have_css 'label', text: 'WMS layers'
      end
    end
  end
  feature 'no wms or wfs provided' do
    scenario 'does not show up in tools' do
      visit solr_document_path 'mit-001145244'
      expect(page).not_to have_css 'li.web_services a', text: 'Web services'
    end
  end
end
