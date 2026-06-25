require "spec_helper"

RSpec.describe Geoblacklight::Configuration::SettingsBuilder do
  describe ".build" do
    subject(:config) { described_class.build }

    it { is_expected.to be_a(Geoblacklight::Configuration) }

    it "reads values from the real Settings (uppercase) constant" do
      expect(config.institution).to eq(Settings.INSTITUTION)
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

      it "resolves uppercase keys even though the builder asks case-insensitively" do
        expect(config.institution).to eq("Stanford")
        expect(config.fields.title).to eq("dct_title_s")
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
end
