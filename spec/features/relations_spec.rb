# frozen_string_literal: true

require "spec_helper"

feature "Display related documents" do
  scenario "Record with dct_source_sm value(s) should have parent(s)" do
    visit relations_solr_document_path("nyu_2451_34502")
    expect(page).to have_css(".relations .card-header h2", text: "Source records...")
  end

  scenario "Record that is pointed to by others should have children" do
    visit relations_solr_document_path("nyu_2451_34635")
    expect(page).to have_css(".relations .card-header h2", text: "Derived records...")
  end

  scenario "Relations should respond to json" do
    visit relations_solr_document_path("nyu_2451_34635", format: "json")
    response = JSON.parse(page.body)
    expect(response["relations"]).not_to respond_to("source_ancestors")
    expect(response["relations"]["source_descendants"]["docs"].first[Settings.FIELDS.ID]).to eq "nyu_2451_34502"
    expect(response["current_doc"]).to eq "nyu_2451_34635"
  end

  scenario "Record with relations should render widget in catalog#show", js: true do
    visit solr_document_path("nyu_2451_34635")
    expect(page).to have_css(".card.relations")
    expect(page).to have_css("div.card-header", text: "Derived records...")
  end

  scenario "Record without relations should not render widget in catalog#show", js: true do
    visit solr_document_path("harvard-g7064-s2-1834-k3")
    expect(page).to have_no_css(".card.relations")
  end

  scenario "Relationship browse link returns relationship-scoped results", js: true do
    # Wabash Topo parent record
    visit solr_document_path("eee6150b-ce2f-4837-9d17-ce72a0c1c26f")

    expect(page).to have_content("Has part...")
    expect(page).to have_link("Browse all 4 records...")
    click_link("Browse all 4 records...")

    expect(page).not_to have_content("No results found for your search")
  end

  scenario "Record with dct_isPartOf_sm value(s) should link to relations", js: true do
    # All Relationships
    visit solr_document_path("all-relationships")
    expect(page).to have_content("Is part of...")
  end

  scenario "Record pointed at by a parent with dct_isPartOf_sm value(s) should link back", js: true do
    # The Related Record
    visit solr_document_path("the-related-record")
    expect(page).to have_content("Has part...")
  end

  scenario "Record with pcdm_memberOf_sm value(s) should link to relations", js: true do
    # All Relationships
    visit solr_document_path("all-relationships")
    expect(page).to have_content("Belongs to collection...")
  end

  scenario "Record pointed at by a parent with pcdm_memberOf_sm value(s) should link back", js: true do
    # The Related Record
    visit solr_document_path("the-related-record")
    expect(page).to have_content("Collection records...")
  end
end
