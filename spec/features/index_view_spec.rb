# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Index view", js: true do
  let(:subject_field) { Geoblacklight.configuration.fields.subject }
  before do
    visit search_catalog_path(q: "*")
  end

  scenario "searching the map should retain current search parameters" do
    visit "/?f[#{subject_field}][]=Population"

    # A reader searches by dragging a box over the map, which the line of text on it says
    expect(find("#overview-map").shadow_root).to have_css(".maplibregl-ctrl-geosearch")
    search_map_area

    within "#appliedParams" do
      expect(page).to have_content("Bounding Box", wait: 10)
      expect(page).to have_content("Subject Population")
    end
  end
end
