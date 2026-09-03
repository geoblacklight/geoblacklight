# frozen_string_literal: true

require "spec_helper"

feature "Configurable basemap", js: true do
  scenario "defaults to positron" do
    visit root_path
    expect(page).to have_css "img[src*='carto']", visible: :all
  end

  feature "without provided basemap config" do
    before do
      CatalogController.blacklight_config.basemap_provider = nil
    end
    scenario "has Carto map" do
      visit root_path
      expect(page).to have_css "img[src*='carto']", visible: :all
    end
  end

  feature "using darkMatter" do
    before do
      CatalogController.blacklight_config.basemap_provider = "darkMatter"
    end
    scenario "has darkMatter map" do
      visit root_path
      expect(page).to have_css "img[src*='dark_all']", visible: :all
    end
  end

  feature "using openstreetmapHot" do
    before do
      CatalogController.blacklight_config.basemap_provider = "openstreetmapHot"
    end
    scenario "has openstreetmapHot map" do
      visit root_path
      expect(page).to have_css "img[src*='hot']", visible: :all
    end
  end

  feature "with a configured tile URL for a shipped basemap" do
    before do
      CatalogController.blacklight_config.basemap_provider = "positron"
      Settings.LEAFLET.BASEMAPS = {
        positron: {
          url: "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png?key=fake-carto-key"
        }
      }
    end
    after { Settings.LEAFLET.BASEMAPS = nil }

    scenario "requests tiles from the configured URL" do
      visit root_path
      expect(page).to have_css "img[src*='key=fake-carto-key']", visible: :all
    end
    scenario "keeps the attribution from the shipped definition" do
      visit root_path
      expect(page).to have_css ".leaflet-control-attribution", text: "Carto"
    end
  end

  feature "with a basemap the application defines itself" do
    before do
      CatalogController.blacklight_config.basemap_provider = "myBasemap"
      Settings.LEAFLET.BASEMAPS = {
        myBasemap: {
          url: "/tiles/{z}/{x}/{y}.png",
          attribution: "Tiles courtesy of Example University",
          maxZoom: 18
        }
      }
    end
    after { Settings.LEAFLET.BASEMAPS = nil }

    scenario "requests tiles from the application's basemap" do
      visit root_path
      # visible: :all because these tiles 404, so the images have no dimensions
      expect(page).to have_css "img[src*='/tiles/']", visible: :all
    end
    scenario "credits the application's basemap" do
      visit root_path
      expect(page).to have_css ".leaflet-control-attribution",
        text: "Tiles courtesy of Example University"
    end
  end

  feature "using a basemap that does not exist" do
    before do
      CatalogController.blacklight_config.basemap_provider = "nonexistent"
    end
    scenario "falls back to positron rather than drawing no basemap" do
      visit root_path
      expect(page).to have_css "img[src*='light_all']", visible: :all
    end
  end
end
