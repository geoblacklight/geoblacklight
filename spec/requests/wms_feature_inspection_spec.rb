# frozen_string_literal: true

require "spec_helper"

describe "wms handle endpoint", type: :request do
  it "returns GeoJSON with feature properties" do
    params = {
      "format" => "json",
      "URL" => "http://127.0.0.1:9000/geoserver/wms",
      "LAYERS" => "gbl:tufts-cambridgegrid100-04",
      "BBOX" => "-71.25045776367189,42.32250876543571,-70.96584320068361,42.43359304732316",
      "HEIGHT" => "438",
      "WIDTH" => "829",
      "QUERY_LAYERS" => "gbl:tufts-cambridgegrid100-04",
      "X" => "432",
      "Y" => "263"
    }
    post("/wms/handle", params: params)
    r = JSON.parse(response.body)
    expect(r.dig("features", 0, "type")).to eq "Feature"
    expect(r.dig("features", 0, "properties", "perimeter")).to eq 10_000
  end
end
