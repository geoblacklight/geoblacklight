# frozen_string_literal: true

require "spec_helper"

feature "Index view", js: true do
  let(:subject_field) { Settings.FIELDS.SUBJECT }
  before do
    visit search_catalog_path(q: "*")
  end

  scenario "should have documents and map on page" do
    visit search_catalog_path(f: {Settings.FIELDS.PROVIDER => ["Stanford"]})
    expect(page).to have_css("#documents")
    expect(page).to have_css(".document", count: 6)
    expect(page).to have_css("#leaflet-viewer")
  end

  scenario "should have sort and per_page on page" do
    visit search_catalog_path(f: {Settings.FIELDS.PROVIDER => ["Stanford"]})
    expect(page).to have_css("#sort-dropdown")
    expect(page).to have_css("#per_page-dropdown")
  end

  scenario "should have facets listed correctly" do
    skip "Capybara thinks elements are not visible or interactable, but they are"

    within "#facet-panel-collapse", visible: :all do
      expect(page).to have_css("div.card.facet-limit", text: "Year", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Place", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Access", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Resource Class", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Resource Type", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Format", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Subject", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Theme", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Creator", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Publisher", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Provider", visible: :all)
      expect(page).to have_css("div.card.facet-limit", text: "Georeferenced", visible: :all)
    end

    click_button "Provider", visible: :all

    expect(page).to have_css("a.facet-select", text: "University of Minnesota", visible: :all)
    expect(page).to have_css("a.facet-select", text: "MIT", visible: :all)
    expect(page).to have_css("a.facet-select", text: "Stanford", visible: :all)
    expect(page).to have_css(".more_facets a", text: /more\sProvider\s»/, visible: :all)
  end

  scenario "hover on record should produce bounding box on map" do
    # Needed to find an svg element on the page
    visit search_catalog_path(f: {Settings.FIELDS.PROVIDER => ["Stanford"]})
    # BL7 has svg icons, so sniffing for SVG path won't return false
    # expect(Nokogiri::HTML.parse(page.body).css('path').length).to eq 0
    find(".documentHeader", match: :first).hover
    within("#leaflet-viewer") do
      expect(page).to have_css("path")
    end
  end

  scenario "click on a record area to expand collapse" do
    within("article", match: :first) do
      expect(page).to have_css(".collapsed")
      find("button").click
      expect(page).not_to have_css(".collapsed")
    end
  end

  scenario "spatial search should reset to page one" do
    skip "FIXME: Only works with a headful browser?"
    visit "/?per_page=5&q=%2A&page=2"
    find("#leaflet-viewer").double_click
    expect(page).to have_css ".page-entries", text: /^1 - 5 of \d.*$/
  end

  scenario "clicking map search should retain current search parameters" do
    visit "/?f[#{subject_field}][]=Population"
    find("#leaflet-viewer").double_click
    within "#appliedParams" do
      expect(page).to have_content("Subject Population")
    end
  end

  scenario "should have schema.org props listed" do
    visit search_catalog_path(f: {Settings.FIELDS.PROVIDER => ["Stanford"]})
    within(".documentHeader", match: :first) do
      expect(page).to have_css("a[itemprop='name']")
      find(".dropdown-toggle").click
    end
    within(".more-info-area", match: :first) do
      expect(page).to have_css("small[itemprop='description']")
    end
  end
end
