# frozen_string_literal: true

require "spec_helper"

feature "saved searches" do
  scenario "list spatial search", js: true do
    visit root_path({bbox: "-180 -89.338214 180 88.918831"})
    visit blacklight.search_history_path
    expect(page).to have_css "td.query a", text: /#{I18n.t("geoblacklight.bbox_label")}/
  end
end
