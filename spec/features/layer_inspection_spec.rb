require 'spec_helper'

feature 'Layer inspection', js: true do
  scenario 'clicking map should trigger inspection' do
    visit solr_document_path('mit-us-ma-e25zcta5dct-2000')
    expect(page).to have_css('th', text: 'Attribute')
    find('#map').trigger('click')
    expect(page).not_to have_css('td.default-text')
  end
end
