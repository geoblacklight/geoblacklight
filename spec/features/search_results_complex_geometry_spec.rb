# frozen_string_literal: true

require "spec_helper"

feature "spatial search results with an WKT bounding box that crosses the anti-meridian" do
  scenario "when searching within the covered area" do
    # BBox param is in China
    visit search_catalog_path(
      q: "A new & accurate map of Asia",
      bbox: "98.4375 31.765537 117.202148 45.429299"
    )
    result_id = page.all("div.documentHeader").first["data-layer-id"]
    expect(result_id).to eq "57f0f116-b64e-4773-8684-96ba09afb549"
  end

  scenario "when searching outside the covered area" do
    # BBox param is in Oklahoma
    visit search_catalog_path(
      q: "A new & accurate map of Asia",
      bbox: "-98.717651 34.40691 -96.37207 36.199958"
    )
    results = page.all("div.documentHeader")
    expect(results.count).to eq 0
  end
end
