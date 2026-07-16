# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Index view", js: true do
  let(:subject_field) { Geoblacklight.configuration.fields.subject }
  before do
    visit search_catalog_path(q: "*")
  end

  scenario "hover on record should produce bounding box on map" do
    # Needed to find an svg element on the page
    visit search_catalog_path(f: {Geoblacklight.configuration.fields.provider => ["Stanford"]})
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

  scenario "clicking map search should retain current search parameters" do
    visit "/?f[#{subject_field}][]=Population"
    find("#leaflet-viewer").double_click
    within "#appliedParams" do
      expect(page).to have_content("Subject Population")
    end
  end
end
