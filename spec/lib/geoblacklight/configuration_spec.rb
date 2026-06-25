require "spec_helper"

RSpec.describe Geoblacklight::Configuration do
  subject(:config) { Geoblacklight::Configuration.new }

  describe "#leaflet_options" do
    subject(:leaflet_options) { config.leaflet_options }

    it "returns a hash of options for leaflet" do
      expect(leaflet_options.layers.index.keys).to eq(%i[DEFAULT UNAVAILABLE SELECTED])
    end

    it "uses LayerConfig instances for index configurations" do
      expect(leaflet_options.layers.index[:DEFAULT]).to be_a(Geoblacklight::Configuration::LayerConfig)
      expect(leaflet_options.layers.index[:DEFAULT].weight).to eq(1)
      expect(leaflet_options.layers.index[:DEFAULT].radius).to eq(4)
      expect(leaflet_options.layers.index[:DEFAULT].color).to eq("#7FCDBB")
      expect(leaflet_options.layers.index[:DEFAULT].sr_color_name).to eq("Green")
    end

    it "serializes layers options correctly with LayerConfig defaults" do
      layers_hash = leaflet_options.to_h[:layers]
      expect(layers_hash).to eq(
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
          },
          SELECTED: {
            color: "#2C7FB8",
            weight: 1,
            radius: 4,
            sr_color_name: "Blue"
          }
        }
      )
    end
  end
end
