require 'spec_helper'

feature 'Index view', js: true do
  before do
    visit catalog_index_path( f: { dct_provenance_s: ['Stanford']})
  end

  scenario 'should have documents and map on page' do
    expect(page).to have_css('#documents')
    expect(page).to have_css(".document", count: 2)
    expect(page).to have_css('#map')
  end

end
