require 'spec_helper'

feature 'Index view', js: true do
  let(:subject_field) { Settings.FIELDS.SUBJECT }
  before do
    visit search_catalog_path(q: '*')
  end

  scenario 'should have documents and map on page' do
    visit search_catalog_path(f: { Settings.FIELDS.PROVENANCE => ['Stanford'] })
    expect(page).to have_css('#documents')
    expect(page).to have_css('.document', count: 3)
    expect(page).to have_css('#map')
  end

  scenario 'should have facets listed correctly' do
    within '#facet-panel-collapse' do
      expect(page).to have_css('div.panel.facet_limit', text: 'Institution')
      expect(page).to have_css('div.panel.facet_limit', text: 'Publisher')
      expect(page).to have_css('div.panel.facet_limit', text: 'Subject')
      expect(page).to have_css('div.panel.facet_limit', text: 'Place')
      expect(page).to have_css('div.panel.facet_limit', text: 'Year')
      expect(page).to have_css('div.panel.facet_limit', text: 'Access')
      expect(page).to have_css('div.panel.facet_limit', text: 'Data type')
      expect(page).to have_css('div.panel.facet_limit', text: 'Format')
    end
    click_link 'Institution'
    expect(page).to have_css('a.facet_select', text: 'Columbia', visible: true)
    expect(page).to have_css('a.facet_select', text: 'MIT', visible: true)
    expect(page).to have_css('a.facet_select', text: 'Stanford', visible: true)
  end

  scenario 'hover on record should produce bounding box on map' do
    # Needed to find an svg element on the page
    visit search_catalog_path(f: { Settings.FIELDS.PROVENANCE => ['Stanford'] })
    expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 0
    find('.documentHeader', match: :first).trigger(:mouseover)
    expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 1
  end

  scenario 'click on a record area to expand collapse' do
    within('.documentHeader', match: :first) do
      expect(page).not_to have_css('.collapse')
      find('.status-icons').trigger('click')
      expect(page).to have_css('.collapse', visible: true)
    end
  end

  scenario 'spatial search should reset to page one' do
    visit '/?per_page=5&q=%2A&page=2'
    find('#map').double_click
    expect(find('.page_entries')).to have_content(/^1 - \d of \d.$/)
  end

  scenario 'clicking map search should retain current search parameters' do
    visit "/?f[#{subject_field}][]=polygon&f[#{subject_field}][]=boundaries"
    find('#map').double_click
    within '#appliedParams' do
      expect(page).to have_content('Subject polygon')
      expect(page).to have_content('Subject boundaries')
      expect(page).to have_css 'span.filterName', text: 'Bounding Box'
    end
  end
end
