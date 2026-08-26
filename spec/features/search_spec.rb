# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Search" do
  scenario "When searching child records from a parent record, supressed records are not hidden", js: true do
    visit "/catalog/princeton-1r66j405w"

    within(".card.relations", visible: :all) do
      expect(page).to have_link(href: /f%5Bdct_source_sm%5D/, visible: :all)
    end

    # The sidebar holds a map of where this record is, and it arrives after the page does - so the
    # link below is still moving until it has been drawn
    map_ready("#locator-map")

    click_link "Browse all 4 items sourced from this item", visible: :all
    expect(page).to have_css ".document", count: 4
  end
end
