# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Search history", type: :request do
  it "describes a spatial search" do
    get root_path(bbox: "-180 -89.338214 180 88.918831")
    get blacklight.search_history_path

    page = Capybara.string(response.body)
    expect(page).to have_css("td.query a", text: /#{I18n.t("geoblacklight.bbox_label")}/)
  end
end
