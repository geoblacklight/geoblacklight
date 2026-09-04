# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::OverviewMapComponent, type: :component do
  let(:url) { "/catalog?q=water" }
  let(:options) { {geosearch: true} }
  let(:homepage_map_geom) { nil }
  let(:light_basemap_url) { nil }
  let(:dark_basemap_url) { nil }

  subject(:map) { page.find("ogm-overview") }

  before do
    # Stubbed for every example, because the one that reads it renders through the hook below
    allow(Geoblacklight.logger).to receive(:warn)
    allow(Geoblacklight.configuration).to receive(:homepage_map_geom).and_return(homepage_map_geom)
    allow(Geoblacklight.configuration).to receive(:light_basemap_url).and_return(light_basemap_url)
    allow(Geoblacklight.configuration).to receive(:dark_basemap_url).and_return(dark_basemap_url)

    with_controller_class(CatalogController) do
      with_request_url(url) do
        render_inline(described_class.new(**options))
      end
    end
  end

  it "renders an overview map that the controller can find and size" do
    expect(map[:id]).to eq "overview-map"
    expect(map[:class]).to eq "viewer overview-map"
    expect(map["data-controller"]).to eq "overview-map"
  end

  it "leaves the theme to the page's color mode" do
    expect(map[:theme]).to be_nil
  end

  describe "the basemap" do
    it "is left to the viewer's own default when none is configured" do
      expect(map["light-basemap"]).to be_nil
      expect(map["dark-basemap"]).to be_nil
    end

    context "when the application configures its own" do
      let(:light_basemap_url) { "https://tiles.example.edu/styles/light/style.json" }
      let(:dark_basemap_url) { "https://tiles.example.edu/styles/dark/style.json" }

      it "names a style document for each mode" do
        expect(map["light-basemap"]).to eq "https://tiles.example.edu/styles/light/style.json"
        expect(map["dark-basemap"]).to eq "https://tiles.example.edu/styles/dark/style.json"
      end
    end

    context "when only the light-mode basemap is configured" do
      let(:light_basemap_url) { "https://tiles.example.edu/styles/light/style.json" }

      it "leaves dark mode to the viewer rather than reusing the light one" do
        expect(map["light-basemap"]).to eq "https://tiles.example.edu/styles/light/style.json"
        expect(map["dark-basemap"]).to be_nil
      end
    end
  end

  it "asks the controller for a search of the area a reader draws, and for the row a number belongs to" do
    expect(map["data-action"]).to eq "boundsChange->overview-map#search highlightChange->overview-map#highlight"
    expect(map["data-overview-map-catalog-url-value"]).to be_present
  end

  # ogm-overview keeps its map alive across a disconnect that turns out to be a reconnect rather than
  # a removal, so the element carrying it can survive a search rather than being rebuilt
  it "is carried over a search" do
    expect(map["data-turbo-permanent"]).to be_present
  end

  describe "searching the map" do
    it "is offered" do
      expect(map[:geosearch]).to eq "true"
    end

    it "says how to go about it in the language the rest of the page is in" do
      expect(map["search-help-text"]).to eq I18n.t("geoblacklight.map.geosearch.search_help")
    end

    context "when there is no searching to do" do
      let(:options) { {} }

      it "is left off entirely, and there is nowhere for a search to go" do
        expect(map[:geosearch]).to be_nil
        expect(map["search-help-text"]).to be_nil
        expect(map["data-overview-map-catalog-url-value"]).to be_nil
      end
    end
  end

  # The area a search is filtered to is the other thing that says where to look; that one is in
  # spec/requests/index_view_spec.rb, where the controller permits the parameter it comes from, and
  # where the box beside the map that restates it for a later search is checked too - view-bounds
  # doesn't need restating the same way, since the home page's default doesn't change request to
  # request the way a search's bounding box does.
  describe "where the map opens by default" do
    context "on the home page" do
      let(:url) { "/" }
      let(:options) { {map_geometry: '{"type":"Polygon","coordinates":[[[-73.58,42.93],[-73.58,41.2],[-69.9,41.2],[-69.9,42.93]]]}', geosearch: true} }

      it "is the box around the geometry the home page is configured to open on" do
        expect(map["view-bounds"]).to eq "-73.58 41.2 -69.9 42.93"
      end
    end

    context "when the home page's configured geometry isn't overridden by the caller" do
      let(:url) { "/" }
      let(:options) { {geosearch: true} }
      let(:homepage_map_geom) { '{"type":"Polygon","coordinates":[[[-73.58,42.93],[-73.58,41.2],[-69.9,41.2],[-69.9,42.93]]]}' }

      it "reads Geoblacklight.configuration.homepage_map_geom as its default" do
        expect(map["view-bounds"]).to eq "-73.58 41.2 -69.9 42.93"
      end
    end

    context "when the configured geometry can't be read" do
      let(:url) { "/" }
      let(:options) { {map_geometry: "somewhere near Boston"} }

      it "is left to the map, and says so" do
        expect(map["view-bounds"]).to be_nil
        expect(Geoblacklight.logger).to have_received(:warn).with(/somewhere near Boston/)
      end
    end

    context "when nothing says where to look" do
      it "is left to the map, which opens on the whole world" do
        expect(map["view-bounds"]).to be_nil
      end
    end
  end
end
