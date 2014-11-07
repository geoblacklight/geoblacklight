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

  scenario 'hover on record should produce bounding box on map' do
    # Needed to find an svg element on the page
    expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 0
    find('.documentHeader', match: :first).trigger(:mouseover)
    expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 1
  end

  scenario 'click on a record area to expand collapse' do
    within('.documentHeader', match: :first) do
      expect(page).to_not have_css('.collapse')
      find('.status-icons').click
      expect(page).to have_css('.collapse', visible: true)
    end
  end

  scenario 'spatial search should reset to page one' do
    visit '/?f%5Bdc_format_s%5D%5B%5D=Shapefile&page=2'
    find("#map").double_click
    expect(find('.page_entries')).to have_content('1 - 10')
  end

end
