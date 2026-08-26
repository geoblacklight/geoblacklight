# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Display related documents" do
  scenario "Record with relations should render widget in catalog#show", js: true do
    visit solr_document_path("nyu_2451_34635")
    expect(page).to have_css(".card.relations", visible: :all, wait: 10)
    expect(page).to have_css("div.card-header", text: "Source of", visible: :all, wait: 10)
  end

  scenario "Record without relations should not render widget in catalog#show", js: true do
    visit solr_document_path("harvard-g7064-s2-1834-k3")
    expect(page).to have_no_css(".card.relations")
  end

  scenario "Relationship browse link returns relationship-scoped results", js: true do
    # Wabash Topo parent record
    visit solr_document_path("eee6150b-ce2f-4837-9d17-ce72a0c1c26f")

    expect(page).to have_content(:all, "Has 4 parts", wait: 10)
    expect(page).to have_link("Browse all 4 parts of this item", visible: :all, wait: 10)

    # Follow the link's href directly rather than clicking it - the sidebar is still drawing
    # asynchronously at this point, which can shift the link out from under a real click.
    browse_all_href = find_link("Browse all 4 parts of this item", visible: :all)[:href]
    visit browse_all_href

    expect(page).not_to have_content("No results found for your search")
  end

  scenario "Record with dct_isPartOf_sm value(s) should link to relations", js: true do
    # All Relationships
    visit solr_document_path("all-relationships")
    expect(page).to have_content(:all, "Part of", wait: 10)
  end

  scenario "Record pointed at by a parent with dct_isPartOf_sm value(s) should link back", js: true do
    # The Related Record
    visit solr_document_path("the-related-record")
    expect(page).to have_content(:all, "Has part", wait: 10)
  end

  scenario "Record with pcdm_memberOf_sm value(s) should link to relations", js: true do
    # All Relationships
    visit solr_document_path("all-relationships")
    expect(page).to have_content(:all, "In collection", wait: 10)
  end

  scenario "Record pointed at by a parent with pcdm_memberOf_sm value(s) should link back", js: true do
    # The Related Record
    visit solr_document_path("the-related-record")
    expect(page).to have_content(:all, "Contains", wait: 10)
  end
end
