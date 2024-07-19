# frozen_string_literal: true

require "spec_helper"

feature "saved searches" do
  scenario "list spatial search", js: true do
    visit root_path
    within "#map" do
      find(".search-control a").click
      expect(page.current_url).to match(/bbox=/)
    end
    if Rails.version == "6.1.7.6"
      visit root_path({bbox: "-180 -89.338214 180 88.918831"})
    end
    visit blacklight.search_history_path
    expect(page).to have_css "td.query a", text: /#{I18n.t("geoblacklight.bbox_label")}/
  end
end
