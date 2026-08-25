# frozen_string_literal: true

require "spec_helper"

RSpec.feature "locator map", js: true do
  # A record with nothing previewable, so its sidebar says where it is instead
  before { visit solr_document_path("princeton-1r66j405w") }

  subject(:map) { map_ready("#locator-map").shadow_root }

  scenario "draws where the record is" do
    expect(drawn_extents("#locator-map")).to eq [[[-74.68, 40.33], [-74.63, 40.37]]]
  end

  # Both of these arrive with the style document, a moment after the map itself - and the globe
  # survives this app setting the theme while the map is still being built
  scenario "opens as a globe, and can be zoomed and flattened" do
    expect(map).to have_css("button.maplibregl-ctrl-globe-enabled", wait: 10)
    expect(map).to have_css("button.maplibregl-ctrl-zoom-in")
  end

  scenario "credits the basemap it borrowed, out of the corner it can spare" do
    # CARTO and OpenStreetMap both require the credit, so it is there to open rather than gone: the
    # empty class comes off once the basemap says who made it, and compact is the collapsed "i"
    expect(map).to have_css(".maplibregl-ctrl-attrib.maplibregl-compact:not(.maplibregl-attrib-empty)", wait: 10)
  end

  scenario "has nothing to search, because a locator answers one question" do
    expect(map).to have_no_css(".maplibregl-ctrl-geosearch")
  end
end
