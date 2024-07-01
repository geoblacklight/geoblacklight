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
    skip "Takes too long in CI" if ENV["CI"]

    within "#facet-panel-collapse" do
      expect(page).to have_css("div.card.facet-limit", text: "Year")
      expect(page).to have_css("div.card.facet-limit", text: "Place")
      expect(page).to have_css("div.card.facet-limit", text: "Access")
      expect(page).to have_css("div.card.facet-limit", text: "Resource Class")
      expect(page).to have_css("div.card.facet-limit", text: "Resource Type")
      expect(page).to have_css("div.card.facet-limit", text: "Format")
      expect(page).to have_css("div.card.facet-limit", text: "Subject")
      expect(page).to have_css("div.card.facet-limit", text: "Theme")
      expect(page).to have_css("div.card.facet-limit", text: "Creator")
      expect(page).to have_css("div.card.facet-limit", text: "Publisher")
      expect(page).to have_css("div.card.facet-limit", text: "Provider")
      expect(page).to have_css("div.card.facet-limit", text: "Georeferenced")
    end

    click_button "Provider"

    expect(page).to have_css("a.facet-select", text: "University of Minnesota", visible: true)
    expect(page).to have_css("a.facet-select", text: "MIT", visible: true)
    expect(page).to have_css("a.facet-select", text: "Stanford", visible: true)
    expect(page).to have_css(".more_facets a", text: /more\sProvider\s»/, visible: true)
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
      expect(page).not_to have_css(".collapse")
      find("button").click
      expect(page).to have_css(".collapse", visible: true)
    end
  end

  scenario "spatial search should reset to page one" do
    visit "/?per_page=5&q=%2A&page=2"
    find("#leaflet-viewer").double_click
    expect(find(".page-entries")).to have_content(/^1 - \d of \d.*$/)
  end

  scenario "clicking map search should retain current search parameters" do
    visit "/?f[#{subject_field}][]=Population"
    find("#leaflet-viewer").double_click
    within "#appliedParams" do
      expect(page).to have_content("Subject Population")
      expect(page).to have_css "span.filter-name", text: "Bounding Box"
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
