# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::Configuration::LeafletConfig do
  subject(:config) { described_class.new }

  describe "#sleep=" do
    it "replaces the default sleep config with a LeafletSleepConfig" do
      config.sleep = {sleep: false, margin_distance: 50, message: "Wake up!"}

      expect(config.sleep).to be_a(Geoblacklight::Configuration::LeafletSleepConfig)
      expect(config.sleep.sleep).to be(false)
      expect(config.sleep.margin_distance).to eq(50)
      expect(config.sleep.message).to eq("Wake up!")
    end

    it "applies LeafletSleepConfig defaults for unspecified attributes" do
      config.sleep = {message: "Custom message"}

      expect(config.sleep.message).to eq("Custom message")
      expect(config.sleep.sleep).to be(true)
      expect(config.sleep.sleeptime).to eq(750)
      expect(config.sleep.waketime).to eq(750)
      expect(config.sleep.background).to eq("rgba(214, 214, 214, .7)")
    end

    it "replaces rather than merges with the previous sleep config" do
      config.sleep = {sleep: false}

      expect(config.sleep.sleep).to be(false)
      expect(config.sleep.margin_distance).to eq(100)
    end

    it "produces a fresh independent object on each assignment" do
      original = config.sleep
      config.sleep = {sleep: false}

      expect(config.sleep).not_to be(original)
      expect(original.sleep).to be(true)
    end

    it "accepts an empty hash, falling back entirely to defaults" do
      config.sleep = {}

      expect(config.sleep).to be_a(Geoblacklight::Configuration::LeafletSleepConfig)
      expect(config.sleep.sleep).to be(true)
      expect(config.sleep.message).to eq("Click to Wake")
    end

    it "is reflected in #to_h" do
      config.sleep = {sleep: false, message: "Hello"}

      expect(config.to_h[:sleep]).to include("sleep" => false, "message" => "Hello")
    end
  end

  describe "#layers=" do
    let(:attributes) do
      {
        detect_retina: false,
        index: {
          DEFAULT: {color: "#7FCDBB", sr_color_name: "Green"},
          UNAVAILABLE: Geoblacklight::Configuration::LayerConfig.new(
            color: "#EDF8B1", sr_color_name: "Yellow"
          )
        }
      }
    end

    it "replaces the default layers config with a LeafletLayersConfig" do
      config.layers = attributes

      expect(config.layers).to be_a(Geoblacklight::Configuration::LeafletLayersConfig)
      expect(config.layers.detect_retina).to be(false)
    end

    it "coerces hash entries under index into LayerConfig instances" do
      config.layers = attributes

      default = config.layers.index[:DEFAULT]
      expect(default).to be_a(Geoblacklight::Configuration::LayerConfig)
      expect(default.color).to eq("#7FCDBB")
      expect(default.sr_color_name).to eq("Green")
      expect(default.weight).to eq(1)
    end

    it "preserves existing LayerConfig instances under index" do
      config.layers = attributes

      unavailable = config.layers.index[:UNAVAILABLE]
      expect(unavailable).to be_a(Geoblacklight::Configuration::LayerConfig)
      expect(unavailable.color).to eq("#EDF8B1")
    end

    it "replaces rather than merges with the previous layers config" do
      config.layers = {index: {DEFAULT: {color: "#000000"}}}

      expect(config.layers.index.keys).to eq([:DEFAULT])
      expect(config.layers.index[:SELECTED]).to be_nil
    end

    it "produces a fresh independent object on each assignment" do
      original = config.layers
      config.layers = {index: {}}

      expect(config.layers).not_to be(original)
      expect(original.index).to include(:DEFAULT, :UNAVAILABLE, :SELECTED)
    end

    it "accepts an empty hash, resulting in an empty index" do
      config.layers = {}

      expect(config.layers).to be_a(Geoblacklight::Configuration::LeafletLayersConfig)
      expect(config.layers.index).to eq({})
    end

    it "is reflected in #to_h" do
      config.layers = attributes

      expect(config.to_h[:layers]).to include(
        "detect_retina" => false,
        "index" => hash_including(
          DEFAULT: {color: "#7FCDBB", weight: 1, radius: 4, sr_color_name: "Green"}
        )
      )
    end
  end
end
