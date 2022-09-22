# frozen_string_literal: true

require "spec_helper"

feature "Search" do
  scenario "Suppressed records are hidden" do
    visit "/?q=Sanborn+Map+Company"
    expect(page).to have_css ".document", count: 1
  end

  scenario "When searching child records from a parent record, supressed records are not hidden", js: true do
    visit "/catalog/princeton-1r66j405w"

    within(".card.relations.relationship-source_descendants") do
      expect(page).to have_link(href: /f%5Bdct_source_sm%5D/)
    end

    click_link "Browse all 4 records..."
    expect(page).to have_css ".document", count: 4
  end

  scenario "When sorting by year desc, highest value sorts first" do
    visit "/?f%5Bschema_provider_s%5D%5B%5D=University+of+Minnesota&sort=gbl_indexYear_im+desc%2C+dct_title_sort+asc"

    first_doc = find(".document", match: :first)

    # Doc with gbl_indexYear_im value: [2014, 2030]
    expect(first_doc["data-document-id"]).to eq("02236876-9c21-42f6-9870-d2562da8e44f")
  end

  scenario "When sorting by year, missing values sort last" do
    visit "/?f%5Bschema_provider_s%5D%5B%5D=University+of+Minnesota&sort=gbl_indexYear_im+desc%2C+dct_title_sort+asc"
    last_doc = find_all(".document").last

    # Doc without gbl_indexYear_im value
    expect(last_doc["data-document-id"]).to eq("05d-03-nogeomtype")
  end
end
