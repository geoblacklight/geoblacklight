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

    describe "display_notes_shown" do
      it "preserves the defaults when DISPLAY_NOTES_SHOWN is absent" do
        expect(described_class.new(settings: {}).build.display_notes_shown).to(
          include(:danger, :info, :tip, :warning)
        )
      end

      it "builds DisplayNoteShownConfig objects from a lowercase hash" do
        settings = {
          display_notes_shown: {
            danger: {
              bootstrap_alert_class: "alert-danger",
              icon: "fire-solid",
              note_prefix: "Danger: "
            }
          }
        }

        result = described_class.new(settings: settings).build.display_notes_shown

        expect(result.keys).to eq([:danger])
        danger = result[:danger]
        expect(danger).to be_a(Geoblacklight::Configuration::DisplayNoteShownConfig)
        expect(danger.bootstrap_alert_class).to eq("alert-danger")
        expect(danger.icon).to eq("fire-solid")
        expect(danger.note_prefix).to eq("Danger: ")
      end

      it "builds each entry as a DisplayNoteShownConfig when multiple are given" do
        settings = {
          display_notes_shown: {
            info: {bootstrap_alert_class: "alert-info", icon: "circle-info-solid", note_prefix: "Info: "},
            tip: {bootstrap_alert_class: "alert-success", icon: "lightbulb-solid", note_prefix: "Tip: "}
          }
        }

        result = described_class.new(settings: settings).build.display_notes_shown

        expect(result.keys).to contain_exactly(:info, :tip)
        expect(result.values).to all(be_a(Geoblacklight::Configuration::DisplayNoteShownConfig))
        expect(result[:tip].note_prefix).to eq("Tip: ")
      end

      it "coerces non-hash values into hashes before constructing the config" do
        struct = Struct.new(:bootstrap_alert_class, :icon, :note_prefix)
        note = struct.new("alert-warning", "triangle-exclamation-solid", "Warning: ")

        settings = {display_notes_shown: {warning: note}}

        result = described_class.new(settings: settings).build.display_notes_shown[:warning]

        expect(result).to be_a(Geoblacklight::Configuration::DisplayNoteShownConfig)
        expect(result.bootstrap_alert_class).to eq("alert-warning")
        expect(result.icon).to eq("triangle-exclamation-solid")
        expect(result.note_prefix).to eq("Warning: ")
      end

      it "supports partially-specified notes by leaving unset attributes blank" do
        settings = {display_notes_shown: {custom: {icon: "star-solid"}}}

        result = described_class.new(settings: settings).build.display_notes_shown[:custom]

        expect(result).to be_a(Geoblacklight::Configuration::DisplayNoteShownConfig)
        expect(result.icon).to eq("star-solid")
        expect(result.bootstrap_alert_class).to be_nil
        expect(result.note_prefix).to be_nil
      end

      it "replaces the defaults entirely rather than merging" do
        settings = {display_notes_shown: {custom: {icon: "star-solid"}}}

        result = described_class.new(settings: settings).build.display_notes_shown

        expect(result.keys).to eq([:custom])
        expect(result).not_to include(:danger, :info, :tip, :warning)
      end

      it "handles an empty display_notes_shown hash" do
        settings = {display_notes_shown: {}}

        expect(described_class.new(settings: settings).build.display_notes_shown).to eq({})
      end

      it "resolves an uppercase DISPLAY_NOTES_SHOWN key for backwards compatibility" do
        allow(Geoblacklight::Deprecation).to receive(:warn)

        settings = {
          DISPLAY_NOTES_SHOWN: {
            danger: {
              bootstrap_alert_class: "alert-danger",
              icon: "fire-solid",
              note_prefix: "Danger: "
            }
          }
        }

        result = described_class.new(settings: settings).build.display_notes_shown[:danger]

        expect(result).to be_a(Geoblacklight::Configuration::DisplayNoteShownConfig)
        expect(result.bootstrap_alert_class).to eq("alert-danger")
        expect(result.icon).to eq("fire-solid")
        expect(result.note_prefix).to eq("Danger: ")
        expect(Geoblacklight::Deprecation).to have_received(:warn).with(a_string_matching(/DISPLAY_NOTES_SHOWN/i))
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
