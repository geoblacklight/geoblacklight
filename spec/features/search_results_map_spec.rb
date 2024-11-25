# frozen_string_literal: true

require "spec_helper"

feature "search results map", js: true do
  scenario "view is scoped to Twin Cities metro area" do
    visit search_catalog_path(q: "Minneapolis")
    expect(page).to have_css "#leaflet-viewer"
    expect(page).to have_css "#leaflet-viewer[data-bounds]"

    bbox = page.find("#leaflet-viewer")["data-bounds"]

    # Example bbox for q: Minneapolis
    # "-94.537353515625,44.004669106432225,-92.208251953125,45.87088761346192"
    left, bottom, right, top = bbox.split(",")
    expect(left.to_f).to be_within(1).of(-94)
    expect(bottom.to_f).to be_within(1).of(44)
    expect(right.to_f).to be_within(1).of(-92)
    expect(top.to_f).to be_within(1).of(45)
  end
end
