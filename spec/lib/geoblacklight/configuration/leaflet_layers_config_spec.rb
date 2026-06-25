# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Configuration::LeafletLayersConfig do
  subject(:config) { described_class.new(attributes) }

  let(:attributes) do
    {
      detect_retina: true,
      index: {
        DEFAULT: {
          color: "#7FCDBB",
          sr_color_name: "Green"
        },
        UNAVAILABLE: Geoblacklight::Configuration::LayerConfig.new(
          color: "#EDF8B1",
          sr_color_name: "Yellow"
        )
      }
    }
  end

  describe "initialization" do
    it "sets detect_retina attribute" do
      expect(config.detect_retina).to be(true)
    end

    it "converts hash elements under index to LayerConfig instances" do
      expect(config.index[:DEFAULT]).to be_a(Geoblacklight::Configuration::LayerConfig)
      expect(config.index[:DEFAULT].color).to eq("#7FCDBB")
      expect(config.index[:DEFAULT].weight).to eq(1) # Uses default weight from LayerConfig
    end

    it "keeps existing LayerConfig instances under index" do
      expect(config.index[:UNAVAILABLE]).to be_a(Geoblacklight::Configuration::LayerConfig)
      expect(config.index[:UNAVAILABLE].color).to eq("#EDF8B1")
      expect(config.index[:UNAVAILABLE].weight).to eq(1) # Uses default weight from LayerConfig
    end
  end

  describe "#to_h" do
    it "serializes index to a hash of hashes" do
      expect(config.to_h).to eq(
        "detect_retina" => true,
        "index" => {
          DEFAULT: {
            color: "#7FCDBB",
            weight: 1,
            radius: 4,
            sr_color_name: "Green"
          },
          UNAVAILABLE: {
            color: "#EDF8B1",
            weight: 1,
            radius: 4,
            sr_color_name: "Yellow"
          }
        }
      )
    end
  end
end
