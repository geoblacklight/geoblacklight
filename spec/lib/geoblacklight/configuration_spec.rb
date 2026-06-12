require 'spec_helper'

RSpec.describe Geoblacklight::Configuration do
  subject(:config) { Geoblacklight::Configuration.new }

  describe "#leaflet_options" do
    subject(:leaflet_options) { config.leaflet_options }

    it "returns a hash of options for leaflet" do
      expect(leaflet_options.layers.index.keys).to eq(%i[DEFAULT UNAVAILABLE SELECTED])
    end
  end
end
