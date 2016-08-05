require 'spec_helper'

feature 'Configurable basemap', js: true do
  scenario 'defaults to positron' do
    visit root_path
    expect(page).to have_css "img[src*='cartodb']"
  end
  feature 'without provided basemap config' do
    before do
      CatalogController.blacklight_config.basemap_provider = nil
    end
    scenario 'has CartoDB map' do
      visit root_path
      expect(page).to have_css "img[src*='cartodb']"
    end
  end
  feature 'using darkMatter' do
    before do
      CatalogController.blacklight_config.basemap_provider = 'darkMatter'
    end
    scenario 'has darkMatter map' do
      visit root_path
      expect(page).to have_css "img[src*='dark_all']"
    end
  end
end
