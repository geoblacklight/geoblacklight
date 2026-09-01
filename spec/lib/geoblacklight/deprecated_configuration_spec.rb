# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::DeprecatedConfiguration do
  let(:root) { Pathname.new(Dir.mktmpdir) }

  after { FileUtils.remove_entry(root) }

  def write_view(path, contents = "")
    full = root.join("app", "views", path)
    FileUtils.mkdir_p(full.dirname)
    File.write(full, contents)
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

    # The masthead moves to a component, and Blacklight has no shared/_header_navbar
    # of its own, so there is no upstream copy for an application to override.
    it "points the site masthead at config.header_component" do
      write_view("shared/_header_navbar.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "app/views/shared/_header_navbar.html.erb overrides shared/_header_navbar, which is " \
        "removed in GeoBlacklight 5; set config.header_component to a subclass of " \
        "Geoblacklight::HeaderComponent instead"
      )

      described_class.warn_about_templates(root)
    end

    # Geoblacklight::HeaderComponent is the site masthead; this partial is the
    # document heading, which GeoBlacklight 5 renders from a slot instead.
    it "points the document heading at the DocumentComponent title slot" do
      write_view("catalog/_show_header_default.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /use the title slot of Geoblacklight::DocumentComponent instead/
      )

      described_class.warn_about_templates(root)
    end

    # The partial's only job is to render a DisplayNoteComponent per note, and that
    # component still exists, so it is the unit an application should override.
    it "points the display note at the component the partial already rendered" do
      write_view("catalog/_show_default_display_note.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /use Geoblacklight::DisplayNoteComponent instead/
      )

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

  describe ".warn_about_locale_keys" do
    def write_locale(contents, name: "geoblacklight.en.yml")
      full = root.join("config", "locales", name)
      FileUtils.mkdir_p(full.dirname)
      File.write(full, contents)
    end

    it "warns about a translation GeoBlacklight 5 stops looking up" do
      write_locale(<<~YAML)
        en:
          geoblacklight:
            citation:
              retrieved_from: "Downloaded from %{document_url}"
      YAML

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "config/locales/geoblacklight.en.yml defines geoblacklight.citation.retrieved_from, which " \
        "GeoBlacklight 5 no longer looks up; GeoBlacklight 5 ends a citation with the document's " \
        "identifier URL, its schema.org/url reference or the catalog URL, rather than with a translated suffix"
      )

      described_class.warn_about_locale_keys(root)
    end

    it "names the replacement key for a renamed provider icon" do
      write_locale("en:\n  blacklight:\n    icon:\n      chicago: The University of Chicago\n")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /blacklight\.icon\.chicago.*looks up blacklight\.icon\.university-of-chicago instead/
      )

      described_class.warn_about_locale_keys(root)
    end

    it "matches a translation into any locale, not just English" do
      write_locale("de:\n  geoblacklight:\n    tools:\n      open_carto: In Carto oeffnen\n")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/defines geoblacklight\.tools\.open_carto/)

      described_class.warn_about_locale_keys(root)
    end

    it "does not warn about translations GeoBlacklight 5 keeps" do
      write_locale("en:\n  geoblacklight:\n    home:\n      title: My Portal\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end

    it "does not warn when the application has no locale files of its own" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end

    it "ignores a locale file it cannot parse" do
      write_locale("en:\n  geoblacklight:\n   : not valid: [\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)
      expect { described_class.warn_about_locale_keys(root) }.not_to raise_error
    end

    it "ignores a locale file that is not a mapping" do
      write_locale("--- just a string\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end
  end

  describe ".warn_about_jquery_animations" do
    it "warns about the line the 4.x install generator injected" do
      write_view("layouts/application.html.erb",
        "<head>\n  <%= javascript_tag '$.fx.off = true;' if Rails.env.test? %>\n</head>")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "app/views/layouts/application.html.erb turns jQuery animations off with $.fx.off, which the " \
        "GeoBlacklight 4 install generator added; GeoBlacklight 5 does not ship jQuery, so remove that " \
        'javascript_tag line or the test environment raises "$ is not defined"'
      )

      described_class.warn_about_jquery_animations(root)
    end

    it "finds the line in any layout, not just the application layout" do
      write_view("layouts/blacklight/base.html.erb", "<%= javascript_tag '$.fx.off = true;' %>")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        %r{layouts/blacklight/base\.html\.erb turns jQuery animations off}
      )

      described_class.warn_about_jquery_animations(root)
    end

    it "does not warn about a layout that does not mention jQuery" do
      write_view("layouts/application.html.erb", "<head><%= csrf_meta_tags %></head>")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_jquery_animations(root)
    end

    it "does not warn when the application has no layouts" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_jquery_animations(root)
    end
  end

  describe ".warn_about_relationship_keys" do
    it "names the stale keys and their replacements in a single warning" do
      allow(described_class).to receive(:setting_present?).and_return(false)
      allow(described_class).to receive(:setting_present?).with("RELATIONSHIPS_SHOWN.MEMBER_OF").and_return(true)
      allow(described_class).to receive(:setting_present?).with("RELATIONSHIPS_SHOWN.REPLACED_BY").and_return(true)

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /Settings\.RELATIONSHIPS_SHOWN defines MEMBER_OF, REPLACED_BY, which GeoBlacklight 4\.1 replaced/
      )

      described_class.warn_about_relationship_keys
    end

    it "maps REPLACED_BY onto REPLACES_DESCENDANTS rather than a key of its own" do
      allow(described_class).to receive(:setting_present?).and_return(false)
      allow(described_class).to receive(:setting_present?).with("RELATIONSHIPS_SHOWN.REPLACED_BY").and_return(true)

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /Rename to REPLACES_DESCENDANTS/
      )

      described_class.warn_about_relationship_keys
    end

    it "stays quiet for a settings file on the current shape" do
      allow(described_class).to receive(:setting_present?).and_return(false)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_relationship_keys
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

  describe ".warn_about_changed_settings" do
    it "warns when a setting still holds the GeoBlacklight 4 default" do
      allow(described_class).to receive(:setting_value).and_return(:something_else)
      allow(described_class).to receive(:setting_value).with("TIMEOUT_DOWNLOAD").and_return(16)

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "Settings.TIMEOUT_DOWNLOAD is set to the GeoBlacklight 4 default 16, which is deprecated; " \
        "GeoBlacklight 5 uses 180 because 16 seconds is too short for many generated downloads"
      )

      described_class.warn_about_changed_settings
    end

    it "leaves a setting alone once the application has chosen its own value" do
      allow(described_class).to receive(:setting_value).and_return("a deliberate choice")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_changed_settings
    end

    it "does not confuse a nil setting with the old default" do
      allow(described_class).to receive(:setting_value).and_return(nil)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_changed_settings
    end
  end

  describe ".warn_about_required_settings" do
    it "warns when a setting GeoBlacklight 5 requires is missing" do
      allow(described_class).to receive(:setting_value).and_return(nil)

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /Settings\.DOWNLOAD_FORMATS\.VECTOR is not set; GeoBlacklight 5 requires it/
      )

      described_class.warn_about_required_settings
    end

    it "stays quiet once the setting is supplied" do
      allow(described_class).to receive(:setting_value).and_return(["Shapefile"])

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_required_settings
    end
  end

  describe ".setting_value" do
    it "returns the value of a top level setting" do
      expect(described_class.setting_value("TIMEOUT_DOWNLOAD")).to eq Settings.TIMEOUT_DOWNLOAD
    end

    it "walks a dotted path, including symbol-keyed settings" do
      expect(described_class.setting_value("WMS_PARAMS.INFO_FORMAT")).to eq Settings.WMS_PARAMS.INFO_FORMAT
    end

    it "is nil when the setting is absent" do
      expect(described_class.setting_value("NO_SUCH_SETTING")).to be_nil
    end

    it "is nil when an ancestor of the path is absent" do
      expect(described_class.setting_value("NO_SUCH_SETTING.NOR_THIS_ONE")).to be_nil
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

  describe ".warn_about_helper_override" do
    it "warns when the application has copied GeoblacklightHelper into app/helpers" do
      FileUtils.mkdir_p(root.join("app", "helpers"))
      File.write(root.join("app", "helpers", "geoblacklight_helper.rb"), "")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /app\/helpers\/geoblacklight_helper\.rb overrides GeoblacklightHelper, which shadows GeoBlacklight's own copy/
      )

      described_class.warn_about_helper_override(root)
    end

    it "stays quiet when the application uses GeoBlacklight's helper" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_helper_override(root)
    end
  end

  describe ".warn_about_stale_setting_values" do
    it "warns when a setting lists a value that stops matching in GeoBlacklight 5" do
      allow(described_class).to receive(:setting_value).and_return([])
      allow(described_class).to receive(:setting_value).with("SIDEBAR_STATIC_MAP").and_return(["iiif", "map"])

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /Settings\.SIDEBAR_STATIC_MAP lists "map", which never matches in GeoBlacklight 5/
      )

      described_class.warn_about_stale_setting_values
    end

    it "stays quiet for the default setting values" do
      allow(described_class).to receive(:setting_value).and_return(["iiif", "iiif_manifest"])

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_stale_setting_values
    end

    it "tolerates a setting that is absent" do
      allow(described_class).to receive(:setting_value).and_return(nil)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_stale_setting_values
    end
  end

  describe ".warn_about_document_overrides" do
    def only_defines(reader, owner, source: "/my/app/app/models/concerns/overrides.rb")
      allow(SolrDocument).to receive(:method_defined?).and_return(false)
      allow(SolrDocument).to receive(:private_method_defined?).and_return(false)
      allow(SolrDocument).to receive(:method_defined?).with(reader).and_return(true)
      allow(SolrDocument).to receive(:instance_method).with(reader)
        .and_return(instance_double(UnboundMethod, owner: owner, source_location: source && [source, 1]))
    end

    it "stays quiet for a stock SolrDocument" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_document_overrides
    end

    it "warns when an application module overrides a reader" do
      stub_const("MyDocumentOverrides", Module.new)
      only_defines("display_note", MyDocumentOverrides)

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /MyDocumentOverrides#display_note overrides Geoblacklight::SolrDocument#display_note/
      )

      described_class.warn_about_document_overrides
    end

    it "stays quiet when the reader is defined in the SolrDocument class body" do
      only_defines("title", SolrDocument)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_document_overrides
    end

    it "stays quiet when GeoBlacklight itself owns the reader" do
      only_defines("display_note", Geoblacklight::SolrDocument)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_document_overrides
    end

    it "ignores a reader that is implemented in C, such as Kernel#format" do
      only_defines("format", Kernel, source: nil)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_document_overrides
    end

    it "tolerates a reader that cannot be resolved" do
      allow(SolrDocument).to receive(:method_defined?).and_return(true)
      allow(SolrDocument).to receive(:instance_method).and_raise(NameError)

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_document_overrides
    end
  end

  describe ".warn_about_catalog_controller" do
    it "reports everything the application's CatalogController needs, as one warning" do
      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /\Aapp\/controllers\/catalog_controller\.rb needs these changes before GeoBlacklight 5: /
      )

      described_class.warn_about_catalog_controller
    end

    it "stays quiet once there is nothing left to change" do
      allow(described_class).to receive(:catalog_controller_problems).and_return([])

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_catalog_controller
    end

    it "never lets a broken controller stop the application booting" do
      allow(described_class).to receive(:catalog_controller_problems).and_raise("boom")

      expect { described_class.warn_about_catalog_controller }.not_to raise_error
    end
  end

  describe ".catalog_controller_problems" do
    subject(:problems) { described_class.catalog_controller_problems(CatalogController) }

    it "flags the removed document presenter" do
      expect(problems).to include(/config\.index\.document_presenter_class = Geoblacklight::DocumentPresenter/)
    end

    it "flags every removed show partial the controller still lists" do
      expect(problems).to include(
        /remove show_default_display_note, show_default_viewer_container, show_default_attribute_table, show_default_viewer_information/
      )
    end

    it "flags each show tool that is still registered with a partial" do
      expect(problems).to include(/register the :arcgis show tool with a `component:`/)
      expect(problems).to include(/register the :data_dictionary show tool with a `component:`/)
      expect(problems).to include(/register the :carto show tool with a `component:`/)
    end

    it "flags the components the controller has to start setting" do
      expect(problems).to include(/config\.show\.document_component = Geoblacklight::DocumentComponent/)
      expect(problems).to include(/config\.index\.document_component = Geoblacklight::SearchResultComponent/)
      expect(problems).to include(/config\.header_component = Geoblacklight::HeaderComponent/)
    end

    it "flags the web_services destructuring" do
      expect(problems).to include(/@response, @documents = action_documents/)
    end

    it "is empty for a controller that has already been migrated" do
      config = CatalogController.blacklight_config.deep_copy
      config.index.document_presenter_class = Blacklight::IndexPresenter
      config.show.partials = [:show_header, :show]
      config.show.document_component = Blacklight::DocumentComponent
      config.index.document_component = Blacklight::DocumentComponent
      config.header_component = Class.new
      described_class::SHOW_TOOL_PARTIALS.each { |tool| config.show.document_actions.delete(tool.to_sym) }
      controller = class_double(CatalogController, blacklight_config: config)
      allow(described_class).to receive(:web_services_problem).with(controller).and_return(nil)

      expect(described_class.catalog_controller_problems(controller)).to be_empty
    end
  end

  describe ".web_services_problem" do
    it "is nil when the controller source cannot be located" do
      controller = class_double(
        CatalogController,
        instance_method: instance_double(UnboundMethod, source_location: nil)
      )

      expect(described_class.web_services_problem(controller)).to be_nil
    end

    it "is nil rather than raising when the source cannot be read" do
      controller = class_double(CatalogController)
      allow(controller).to receive(:instance_method).and_raise("boom")

      expect(described_class.web_services_problem(controller)).to be_nil
    end
  end

  describe ".warn!" do
    it "checks templates, removed settings, changed defaults and required settings" do
      expect(described_class).to receive(:warn_about_templates).with(root)
      expect(described_class).to receive(:warn_about_settings)
      expect(described_class).to receive(:warn_about_changed_settings)
      expect(described_class).to receive(:warn_about_required_settings)
      expect(described_class).to receive(:warn_about_stale_setting_values)
      expect(described_class).to receive(:warn_about_helper_override).with(root)
      expect(described_class).to receive(:warn_about_locale_keys).with(root)
      expect(described_class).to receive(:warn_about_jquery_animations).with(root)
      expect(described_class).to receive(:warn_about_relationship_keys)
      expect(described_class).to receive(:warn_about_document_overrides)
      expect(described_class).to receive(:warn_about_catalog_controller)

      described_class.warn!(root)
    end

    it "skips the template check when there is no application root" do
      expect(described_class).not_to receive(:warn_about_templates)
      allow(described_class).to receive(:warn_about_settings)
      allow(described_class).to receive(:warn_about_changed_settings)
      allow(described_class).to receive(:warn_about_required_settings)
      allow(described_class).to receive(:warn_about_stale_setting_values)
      expect(described_class).not_to receive(:warn_about_helper_override)
      expect(described_class).not_to receive(:warn_about_locale_keys)
      expect(described_class).not_to receive(:warn_about_jquery_animations)
      allow(described_class).to receive(:warn_about_relationship_keys)
      allow(described_class).to receive(:warn_about_document_overrides)
      allow(described_class).to receive(:warn_about_catalog_controller)

      described_class.warn!(nil)
    end
  end
end
