require "spec_helper"

RSpec.describe Geoblacklight::Configuration::DefaultSettingsBuilder do
  describe ".build" do
    it "returns a Geoblacklight::Configuration object" do
      expect(described_class.build).to be_a(Geoblacklight::Configuration)
    end
  end
end
