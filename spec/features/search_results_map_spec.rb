# frozen_string_literal: true

require "spec_helper"

RSpec.feature "search results map", js: true do
  before { visit search_catalog_path(q: "Minneapolis") }

  scenario "draws where each result is, numbered the way the list beside it is" do
    expect(drawn_extents.count).to eq page.all(".document").count

    # The map counts from one over everything it was given, and the counter beside a result counts
    # from the start of the whole result set - so on the first page of results the two agree
    expect(page.all(".document").map { |result| result["data-document-counter"] })
      .to eq (1..drawn_extents.count).map(&:to_s)
  end

  scenario "view is scoped to Twin Cities metro area" do
    # Example extent for q: Minneapolis
    # [[-94.012, 44.471], [-92.732, 45.415]]
    (west, south), (east, north) = drawn_extents.first

    expect(west).to be_within(1).of(-94)
    expect(south).to be_within(1).of(44)
    expect(east).to be_within(1).of(-92)
    expect(north).to be_within(1).of(45)
  end

  scenario "comes back knowing the area the reader searched" do
    # The line of text saying how to search goes up with the map
    expect(find("#overview-map").shadow_root).to have_css(".maplibregl-ctrl-geosearch")

    search_map_area

    within "#appliedParams" do
      expect(page).to have_content("Bounding Box", wait: 10)
    end

    # A map that draws, rather than an empty box
    expect(find("#overview-map").shadow_root).to have_css("canvas.maplibregl-canvas")

    # ...and one that has been told what the results were narrowed to, which is what it points
    # itself at: the results themselves can't do that job, because a bbox query matches everything
    # that *intersects* the box and a single continent-wide dataset among them would frame a continent.
    # Read as a property rather than the search-bounds attribute: the map is carried over this search
    # rather than rebuilt, so its attribute is frozen at whatever it was on the first render, and it's
    # the live property the controller corrects on reconnect that the map actually goes by.
    expect(page.evaluate_script("document.querySelector('#overview-map').searchBounds")).to eq searched_bbox
  end

  scenario "keeps the same map, canvas and all, rather than rebuilding it" do
    map = map_ready
    canvas = map.shadow_root.find("canvas.maplibregl-canvas", visible: :all)
    page.execute_script("arguments[0].dataset.probe = 'kept-map'", map)
    page.execute_script("arguments[0].dataset.probe = 'kept-canvas'", canvas)

    search_map_area

    within "#appliedParams" do
      expect(page).to have_content("Bounding Box", wait: 10)
    end

    # A freshly built element or WebGL canvas would start without these - they are set by hand above,
    # not by the server or component. Keeping both is what avoids another map load and tile fetch.
    carried = find("#overview-map")
    expect(carried["data-probe"]).to eq "kept-map"
    expect(carried.shadow_root.find("canvas.maplibregl-canvas", visible: :all)["data-probe"]).to eq "kept-canvas"

    # And it's been given the narrowed results to draw, not left showing what it had before
    expect(drawn_extents.count).to eq page.all(".document").count
  end

  describe "pointing at a result" do
    let(:result) { page.all(".document").first }
    let(:layer_id) { result["data-map-id"] }

    scenario "from the list tells the map which one it is" do
      map_ready
      result.hover

      expect(page.evaluate_script("document.querySelector('#overview-map').highlighted")).to eq layer_id
    end

    scenario "on the map marks its row in the list" do
      map = map_ready

      # As the map reports a reader's pointer landing on a number. Sent here rather than pointed at,
      # because the numbers are drawn into a canvas inside the map's own shadow root, and where each
      # of them lands on screen is the map's business.
      page.execute_script(<<~JS, map, layer_id)
        const [map, id] = arguments
        map.dispatchEvent(new CustomEvent("highlightChange", { detail: { place: 1, id } }))
      JS

      expect(result[:class]).to include "highlighted"
    end
  end
end
