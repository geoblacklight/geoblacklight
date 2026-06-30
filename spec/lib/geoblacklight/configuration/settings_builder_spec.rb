require "spec_helper"

RSpec.describe Geoblacklight::Configuration::SettingsBuilder do
  describe ".build" do
    before {
      Settings.institution = "MIT"
    }
    subject(:config) { described_class.build }

    it "reads values from the real Settings (lowercase) constant" do
      expect(config.institution).to eq("MIT")
    end
  end

  describe "#build" do
    subject(:config) { described_class.new(settings: settings).build }

    describe "reading lowercase keys" do
      let(:settings) do
        {
          institution: "MIT",
          fields: {title: "my_title_s"},
          download_formats: {vector: ["GeoJSON"]},
          leaflet: {selected_color: "#abc123", sidebar: true}
        }
      end

      it "resolves top-level lowercase keys" do
        expect(config.institution).to eq("MIT")
      end

      it "resolves nested lowercase keys" do
        expect(config.fields.title).to eq("my_title_s")
        expect(config.vector_download_formats).to eq(["GeoJSON"])
        expect(config.leaflet_options.selected_color).to eq("#abc123")
        expect(config.leaflet_options.sidebar).to be true
      end
    end

    describe "reading uppercase keys (backwards compatibility)" do
      let(:settings) do
        {
          INSTITUTION: "Stanford",
          FIELDS: {TITLE: "dct_title_s"}
        }
      end

      before { allow(Geoblacklight::Deprecation).to receive(:warn) }

      it "resolves uppercase keys even though the builder asks case-insensitively" do
        expect(config.institution).to eq("Stanford")
        expect(config.fields.title).to eq("dct_title_s")
      end
    end

    describe "deprecation warnings" do
      before { allow(Geoblacklight::Deprecation).to receive(:warn) }

      it "warns when an uppercase key is resolved" do
        described_class.new(settings: {INSTITUTION: "MIT"}).build
        expect(Geoblacklight::Deprecation).to have_received(:warn).with(a_string_matching(/INSTITUTION/i))
      end

      it "warns about nested uppercase keys" do
        described_class.new(settings: {fields: {TITLE: "dct_title_s"}}).build
        expect(Geoblacklight::Deprecation).to have_received(:warn).with(a_string_matching(/TITLE/i))
      end

      it "does not warn when keys are lowercase" do
        described_class.new(settings: {institution: "MIT", fields: {title: "x"}}).build
        expect(Geoblacklight::Deprecation).not_to have_received(:warn)
      end

      it "does not warn when a lowercase key shadows an uppercase one" do
        described_class.new(settings: {institution: "lower", INSTITUTION: "UPPER"}).build
        expect(Geoblacklight::Deprecation).not_to have_received(:warn)
      end
    end

    describe "when both cases are present" do
      let(:settings) { {institution: "lower", INSTITUTION: "UPPER"} }
      it "prefers the lowercase value" do
        expect(config.institution).to eq("lower")
      end
    end

    describe "missing keys" do
      let(:settings) { {} }
      it "fall back to the Configuration defaults" do
        expect(config.institution).to eq("Stanford")
      end
    end
  end
end

RSpec.describe Geoblacklight::Configuration::CaseInsensitiveSettings do
  subject(:wrapper) { described_class.new(settings) }

  describe "method access" do
    let(:settings) { {ARCgis_BASE_URL: "https://example.com"} }

    it "resolves keys case-insensitively" do
      expect(wrapper.arcgis_base_url).to eq("https://example.com")
      expect(wrapper.ARCGIS_BASE_URL).to eq("https://example.com")
      expect(wrapper.Arcgis_Base_Url).to eq("https://example.com")
    end

    it "returns nil for unknown keys" do
      expect(wrapper.does_not_exist).to be_nil
    end
  end

  describe "[] access" do
    let(:settings) { {INSTITUTION: "MIT"} }

    it "resolves via bracket access" do
      expect(wrapper[:institution]).to eq("MIT")
      expect(wrapper[:INSTITUTION]).to eq("MIT")
    end
  end

  describe "nested access" do
    let(:settings) { {FIELDS: {TITLE: "dct_title_s"}} }

    it "wraps nested hashes so chained access resolves" do
      expect(wrapper.fields.title).to eq("dct_title_s")
      expect(wrapper.FIELDS.TITLE).to eq("dct_title_s")
    end
  end

  describe "lowercase preference" do
    let(:settings) { {institution: "lower", INSTITUTION: "UPPER"} }

    it "returns the lowercase value when both forms exist" do
      expect(wrapper.institution).to eq("lower")
    end
  end

  describe "to_h" do
    let(:settings) { {FOO: "bar"} }

    it "returns the underlying hash" do
      expect(wrapper.to_h).to eq({FOO: "bar"})
    end
  end

  describe "deprecation warnings" do
    it "warns when an uppercase key is used" do
      deprecation = double("deprecation")
      expect(deprecation).to receive(:warn).with(a_string_matching(/INSTITUTION/i))
      described_class.new({INSTITUTION: "MIT"}, deprecation: deprecation).institution
    end

    it "warns about nested uppercase keys" do
      deprecation = double("deprecation")
      allow(deprecation).to receive(:warn)
      described_class.new({FIELDS: {TITLE: "x"}}, deprecation: deprecation).fields.title
      expect(deprecation).to have_received(:warn).with(a_string_matching(/FIELDS/i))
      expect(deprecation).to have_received(:warn).with(a_string_matching(/TITLE/i))
    end

    it "does not warn when the resolved key is lowercase" do
      deprecation = double("deprecation")
      expect(deprecation).not_to receive(:warn)
      described_class.new({institution: "MIT"}, deprecation: deprecation).institution
    end

    it "does not warn when a lowercase key shadows an uppercase one" do
      deprecation = double("deprecation")
      expect(deprecation).not_to receive(:warn)
      described_class.new({institution: "lower", INSTITUTION: "UPPER"}, deprecation: deprecation).institution
    end

    it "does not warn by default (no deprecation configured)" do
      expect { described_class.new({INSTITUTION: "MIT"}).institution }.not_to raise_error
    end
  end
end
