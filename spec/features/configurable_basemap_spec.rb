require 'spec_helper'

feature 'Configurable basemap', js: true do
  scenario 'defaults to mapquest' do
    visit root_path
    expect(page).to have_css "img[src*='mqcdn.com']"
  end
  feature 'without provided basemap config' do
    before do
      CatalogController.blacklight_config.basemap_provider = nil
    end
    scenario 'has mapquest map' do
      visit root_path
      expect(page).to have_css "img[src*='mqcdn.com']"
    end
  end
  feature 'using positron' do
    before do
      CatalogController.blacklight_config.basemap_provider = 'positron'
    end
    scenario 'has positron map' do
      visit root_path
      expect(page).to have_css "img[src*='light_all']"
    end
  end
end
