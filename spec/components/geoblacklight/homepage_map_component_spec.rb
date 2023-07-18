# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::HomepageMapComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(basemap: "positron",
      catalog_path: "/catalog",
      leaflet_options: Settings.LEAFLET.to_h,
      map_geometry: Settings.HOMEPAGE_MAP_GEOM))
  end

  it "renders the map" do
    expect(rendered).to have_selector "div#map"
    expect(rendered).to have_selector "h3"
  end
end
