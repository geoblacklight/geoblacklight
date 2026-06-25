# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Configuration::LayerConfig do
  subject(:config) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe "defaults" do
    it "has weight defaulting to 1" do
      expect(config.weight).to eq(1)
    end

    it "has radius defaulting to 4" do
      expect(config.radius).to eq(4)
    end

    it "has color defaulting to nil" do
      expect(config.color).to be_nil
    end

    it "has sr_color_name defaulting to nil" do
      expect(config.sr_color_name).to be_nil
    end
  end

  describe "with attributes" do
    let(:attributes) { {color: "#FF0000", sr_color_name: "Red", weight: 2, radius: 5} }

    it "sets the passed-in attributes" do
      expect(config.color).to eq("#FF0000")
      expect(config.sr_color_name).to eq("Red")
      expect(config.weight).to eq(2)
      expect(config.radius).to eq(5)
    end
  end

  describe "hash-like access []" do
    let(:attributes) { {color: "#00FF00", sr_color_name: "Green"} }

    it "supports key lookup with symbols" do
      expect(config[:color]).to eq("#00FF00")
      expect(config[:weight]).to eq(1)
      expect(config[:sr_color_name]).to eq("Green")
    end

    it "supports key lookup with strings" do
      expect(config["color"]).to eq("#00FF00")
      expect(config["weight"]).to eq(1)
      expect(config["sr_color_name"]).to eq("Green")
    end

    it "returns nil for non-existent attributes" do
      expect(config[:foo]).to be_nil
    end
  end

  describe "#to_h" do
    let(:attributes) { {color: "#FFFF00", sr_color_name: "Yellow"} }

    it "returns symbolized attributes hash" do
      expect(config.to_h).to eq(
        color: "#FFFF00",
        weight: 1,
        radius: 4,
        sr_color_name: "Yellow"
      )
    end
  end
end
