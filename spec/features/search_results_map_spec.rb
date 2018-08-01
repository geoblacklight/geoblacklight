require 'spec_helper'

feature 'search results map', js: true do
  scenario 'present on a search result page' do
    visit search_catalog_path(q: 'Minnesota')
    expect(page).to have_css '#map'
  end
  scenario 'present on a search result page' do
    visit root_path
    click_link 'Minnesota, United States'
    results = page.all(:css, 'article.document')
    expect(results.count).to equal(4)
  end
  scenario 'view is scoped to Minnesota' do
    visit root_path
    click_link 'Minnesota, United States'
    expect(page).to have_css '#map'
    bbox = page.find('#map')['data-js-map-render-bbox']

    # Example bbox for Place > Minnesota, United States:
    # "-101.90917968749999,38.75408327579141,-83.27636718749999,53.27835301753182"
    left, bottom, right, top = bbox.split(',')
    expect(left.to_f).to be_within(2).of(-101)
    expect(bottom.to_f).to be_within(2).of(38)
    expect(right.to_f).to be_within(2).of(-83)
    expect(top.to_f).to be_within(2).of(53)
  end
  scenario 'view is scoped to Twin Cities metro area' do
    visit search_catalog_path(q: 'Minneapolis')
    expect(page).to have_css '#map'
    bbox = page.find('#map')['data-js-map-render-bbox']

    # Example bbox for q: Minneapolis
    # "-94.537353515625,44.004669106432225,-92.208251953125,45.87088761346192"
    left, bottom, right, top = bbox.split(',')
    expect(left.to_f).to be_within(1).of(-94)
    expect(bottom.to_f).to be_within(1).of(44)
    expect(right.to_f).to be_within(1).of(-92)
    expect(top.to_f).to be_within(1).of(45)
  end
  scenario 'view is scoped to NYC' do
    visit root_path
    click_link 'New York, New York, United States'
    expect(page).to have_css '#map'
    bbox = page.find('#map')['data-js-map-render-bbox']

    # Example bbox for Place > New York, New York, United States
    # "-74.26895141601562,40.455307212131494,-73.68667602539061,40.95501133048621"
    left, bottom, right, top = bbox.split(',')
    expect(left.to_f).to be_within(2).of(-74)
    expect(bottom.to_f).to be_within(2).of(40)
    expect(right.to_f).to be_within(2).of(-73)
    expect(top.to_f).to be_within(2).of(40)
  end
  scenario 'swlng is less than 0 and less than nelat' do
    visit search_catalog_path(q: 'East Asia and Oceania.')
    expect(page).to have_css '#map'
    bbox = page.find('#map')['data-js-map-render-bbox']
    # Example bbox for q: East Asia and Oceania.
    # "-298.12500000000006,-89.68308276560911,298.12500000000006,89.68308276560914"
    left, bottom, right, top = bbox.split(',')
    expect(left.to_f).to be_within(1).of(-298)
    expect(bottom.to_f).to be_within(1).of(-89)
    expect(right.to_f).to be_within(1).of(298)
    expect(top.to_f).to be_within(1).of(89)
  end
  scenario 'longitude crosses the antimeridian - area of Alaska' do
    visit solr_document_path 'stanford-zn545gm0023'
    expect(page).to have_css '#map'
    bbox = page.find('#map')['data-map-bbox']
    # Example bbox for show page of 100-Meter Resolution Color-Sliced Elevation of Alaska
    # "-179.9999845 43.0532272 179.9993566 71.9545187"
    left, bottom, right, top = bbox.split(' ')
    expect(left.to_f).to be_within(1).of(-179)
    expect(bottom.to_f).to be_within(1).of(43)
    expect(right.to_f).to be_within(1).of(179)
    expect(top.to_f).to be_within(1).of(71)
  end
end
