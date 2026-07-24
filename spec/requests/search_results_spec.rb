# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Search results", type: :request do
  def response_page
    Capybara.string(response.body)
  end

  def result_ids
    response_page.all(".documentHeader").map { |element| element["data-layer-id"] }
  end

  it "handles a WKT bounding box that crosses the anti-meridian" do
    get search_catalog_path(
      q: "A new & accurate map of Asia",
      bbox: "98.4375 31.765537 117.202148 45.429299"
    )
    expect(result_ids.first).to eq("57f0f116-b64e-4773-8684-96ba09afb549")

    get search_catalog_path(
      q: "A new & accurate map of Asia",
      bbox: "-98.717651 34.40691 -96.37207 36.199958"
    )
    expect(result_ids).to be_empty
  end

  it "renders the geometry and access icons for a result" do
    get search_catalog_path(search_field: "all_fields", q: "stanford-cg357zz0321")

    expect(response_page).to have_css(".status-icons .blacklight-icons-line")
    expect(response_page).to have_css(".status-icons .blacklight-icons-restricted")
  end

  it "uses overlap ratio to rank fully contained bounding boxes" do
    allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return(200)

    get search_catalog_path(
      bbox: "-103.196521 39.21962 -84.431873 53.63497",
      f: {Geoblacklight.configuration.fields.provider => ["University of Minnesota"]}
    )

    expect(result_ids).to start_with(
      "e9c71086-6b25-4950-8e1c-84c2794e3382",
      "2eddde2f-c222-41ca-bd07-2fd74a21f4de",
      "02236876-9c21-42f6-9870-d2562da8e44f"
    )
  end

  it "uses overlap ratio to rank partially overlapping bounding boxes" do
    allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return(200)

    get search_catalog_path(
      bbox: "-83.750499 40.41709 -74.368175 47.963663",
      f: {Geoblacklight.configuration.fields.provider => ["Cornell"]}
    )

    expect(result_ids.index("cugir-008186")).to be < 3
    expect(result_ids.index("cugir-008186-no-downloadurl")).to be < 3
    expect(result_ids.index("cugir-007741")).to eq(3)
  end
end
