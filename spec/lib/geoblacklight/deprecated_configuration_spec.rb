# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::DeprecatedConfiguration do
  let(:root) { Pathname.new(Dir.mktmpdir) }

  after { FileUtils.remove_entry(root) }

  def write_view(path)
    full = root.join("app", "views", path)
    FileUtils.mkdir_p(full.dirname)
    File.write(full, "")
  end

  describe ".warn_about_templates" do
    it "warns about an overridden template, naming the file and its replacement" do
      write_view("catalog/_show_sidebar.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "app/views/catalog/_show_sidebar.html.erb overrides catalog/_show_sidebar, which is " \
        "removed in GeoBlacklight 5; use Geoblacklight::Document::SidebarComponent instead"
      )

      described_class.warn_about_templates(root)
    end

    it "warns about a template with no replacement" do
      write_view("catalog/_show_default_viewer_information.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/it is removed without replacement/)

      described_class.warn_about_templates(root)
    end

    it "does not warn when the application has no overrides" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_templates(root)
    end

    it "does not warn about templates GeoBlacklight 5 keeps" do
      write_view("catalog/_home_text.html.erb")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_templates(root)
    end

    it "does not mistake a similarly named template for an override" do
      write_view("catalog/_show_sidebar_extra.html.erb")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_templates(root)
    end

    it "finds overrides regardless of template handler" do
      write_view("relation/_relations.html.haml")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /_relations\.html\.haml overrides relation\/_relations/
      )

      described_class.warn_about_templates(root)
    end
  end

  describe ".warn_about_settings" do
    it "warns about a removed setting that the application has set" do
      allow(described_class).to receive(:setting_present?).and_return(false)
      allow(described_class).to receive(:setting_present?).with("CARTO_ONECLICK_LINK").and_return(true)

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "Settings.CARTO_ONECLICK_LINK is deprecated and will be removed in GeoBlacklight 5; " \
        "the Carto OneClick integration is removed without replacement"
      )

      described_class.warn_about_settings
    end

    it "does not warn about a removed setting the application has not set" do
      allow(described_class).to receive(:setting_present?).and_return(false)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_settings
    end
  end

  describe ".setting_present?" do
    it "is true for a setting that is present" do
      expect(described_class.setting_present?("CARTO_ONECLICK_LINK")).to be true
    end

    it "is true for a nested setting that is present" do
      expect(described_class.setting_present?("LEAFLET.VIEWERS")).to be true
    end

    it "is false for a setting that is absent" do
      expect(described_class.setting_present?("NO_SUCH_SETTING")).to be false
    end

    it "is false when an ancestor of a nested setting is absent" do
      expect(described_class.setting_present?("NO_SUCH_SETTING.NOR_THIS_ONE")).to be false
    end
  end

  describe ".warn!" do
    it "checks templates and settings" do
      expect(described_class).to receive(:warn_about_templates).with(root)
      expect(described_class).to receive(:warn_about_settings)

      described_class.warn!(root)
    end

    it "skips the template check when there is no application root" do
      expect(described_class).not_to receive(:warn_about_templates)
      allow(described_class).to receive(:warn_about_settings)

      described_class.warn!(nil)
    end
  end
end
