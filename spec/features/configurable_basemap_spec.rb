# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Configurable basemap", js: true do
  scenario "defaults to positron" do
    visit root_path
    expect(page).to have_css "img[src*='carto']", visible: :all
  end

  feature "without provided basemap config" do
    before do
      Geoblacklight.configuration.basemap_provider = nil
    end
    scenario "has Carto map" do
      visit root_path
      expect(page).to have_css "img[src*='carto']", visible: :all
    end
  end

  feature "using dark matter" do
    before do
      Geoblacklight.configuration.basemap_provider = "dark_matter"
    end
    scenario "has dark matter map" do
      visit root_path
      expect(page).to have_css "img[src*='dark_all']", visible: :all
    end
  end

  feature "using openstreetmap hot" do
    before do
      Geoblacklight.configuration.basemap_provider = "openstreetmap_hot"
    end
    scenario "has openstreetmap hot map" do
      visit root_path
      expect(page).to have_css "img[src*='hot']", visible: :all
    end
  end
end
