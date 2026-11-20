# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::BoundingBox do
  describe "#initialize" do
    it "handles multiple input types as arguments" do
      expect(described_class.new("1", "1", "1", "1")).to be_an described_class
      expect(described_class.new(1, 2, 3, 3)).to be_an described_class
      expect(described_class.new(1.1, 2.1, 3.1, 3.1)).to be_an described_class
    end
  end
  describe "#to_envelope" do
    let(:example_box) { described_class.new(-160, -80, 120, 70) }
    it "creates an envelope syntax version of the bounding box" do
      expect(example_box.to_envelope).to eq "ENVELOPE(-160, 120, 70, -80)"
    end
  end
  describe "#to_geojson" do
    let(:example_box) { described_class.new(-160, -80, 120, 70) }

    it "creates a GeoJSON polygon around the bounding box" do
      expect(JSON.parse(example_box.to_geojson)).to eq(
        "type" => "Polygon",
        "coordinates" => [[
          [-160.0, -80.0],
          [-160.0, 70.0],
          [120.0, 70.0],
          [120.0, -80.0],
          [-160.0, -80.0]
        ]]
      )
    end
  end
  describe "#to_degrees_minutes" do
    it "renders each coordinate in degrees and minutes with a hemisphere" do
      box = described_class.new(-18.97461025478958, 10.024127812187103, 25.1234, 40)
      expect(box.to_degrees_minutes).to eq "18°58′W 10°01′N 25°07′E 40°00′N"
    end

    it "carries rounding over into the degrees" do
      box = described_class.new("-71.999", "42.016666", "-70.5", "42.995")
      expect(box.to_degrees_minutes).to eq "72°00′W 42°01′N 70°30′W 43°00′N"
    end

    it "leaves off the hemisphere for coordinates at zero" do
      box = described_class.new(-0.001, 0, 180, 90)
      expect(box.to_degrees_minutes).to eq "0°00′ 0°00′ 180°00′E 90°00′N"
    end

    it "falls back to the Solr rectangle syntax for non-numeric coordinates" do
      box = described_class.new("west", "-80", "120", "70")
      expect(box.to_degrees_minutes).to eq "west -80 120 70"
    end
  end
  describe "#from_rectangle" do
    let(:example_box) { described_class.from_rectangle("-160 -80 120 70") }
    it "parses and creates a Geoblacklight::BoundingBox from a Solr lat-lon" do
      expect(example_box).to be_an described_class
      expect(example_box.to_envelope).to eq "ENVELOPE(-160, 120, 70, -80)"
    end
    it "checks for valididity" do
      expect { described_class.from_rectangle("-160 -80 120") }.to raise_error Geoblacklight::Exceptions::WrongBoundingBoxFormat
    end
  end
end
