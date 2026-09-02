# frozen_string_literal: true

require "spec_helper"

describe Geoblacklight::DeprecatedConfiguration do
  let(:root) { Pathname.new(Dir.mktmpdir) }

  after { FileUtils.remove_entry(root) }

  def write(path, contents = "")
    full = root.join(path)
    FileUtils.mkdir_p(full.dirname)
    File.write(full, contents)
    full
  end

  describe ".warn_about_templates" do
    it "warns about an overridden template, naming the file and its replacement" do
      write("app/views/catalog/_metadata.html.erb")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        "app/views/catalog/_metadata.html.erb overrides catalog/_metadata, which is removed in " \
        "GeoBlacklight 6; use Geoblacklight::MetadataComponent instead"
      )

      described_class.warn_about_templates(root)
    end

    it "catches the relations templates whatever their handler" do
      write("app/views/relation/index.json.jbuilder")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/index\.json\.jbuilder overrides relation\/index/)

      described_class.warn_about_templates(root)
    end

    it "does not warn when the application has no overrides" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_templates(root)
    end

    it "does not warn about templates GeoBlacklight 6 keeps" do
      write("app/views/catalog/_home_text.html.erb")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_templates(root)
    end
  end

  describe ".warn_about_routes" do
    it "warns when the application's routes still name a removed constant" do
      write("config/routes.rb", <<~RUBY)
        Rails.application.routes.draw do
          concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
        end
      RUBY

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /config\/routes\.rb needs these changes before GeoBlacklight 6: GeoBlacklight 6 removes the generated download subsystem/
      )

      described_class.warn_about_routes(root)
    end

    it "stays quiet once the download routes are gone" do
      write("config/routes.rb", "Rails.application.routes.draw do\nend\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_routes(root)
    end

    it "stays quiet when there is no routes file" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_routes(root)
    end

    it "never lets an unreadable routes file stop the application booting" do
      path = write("config/routes.rb", "")
      allow(File).to receive(:read).with(path.to_s).and_raise(Errno::EACCES)

      expect { described_class.warn_about_routes(root) }.not_to raise_error
    end
  end

  describe ".warn_about_asset_references" do
    it "reports every dead reference in a stylesheet as one warning" do
      write("app/assets/stylesheets/application.bootstrap.scss", <<~SCSS)
        @import '@geoblacklight/frontend/app/assets/stylesheets/geoblacklight/geoblacklight';
        $logo-image: url("images/blacklight/logo.svg");
      SCSS

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /application\.bootstrap\.scss needs these changes before GeoBlacklight 6: .*geoblacklight\/geoblacklight.*; .*logo\.svg/m
      )

      described_class.warn_about_asset_references(root)
    end

    it "looks at the Vite entrypoints too" do
      write("app/javascript/stylesheets/geoblacklight.scss",
        "@import '@geoblacklight/frontend/app/assets/stylesheets/geoblacklight/geoblacklight.scss';")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/app\/javascript\/stylesheets\/geoblacklight\.scss/)

      described_class.warn_about_asset_references(root)
    end

    it "stays quiet for a stylesheet with nothing dead in it" do
      write("app/assets/stylesheets/application.bootstrap.scss", "@import 'bootstrap/scss/bootstrap';")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_asset_references(root)
    end

    it "never lets an unreadable stylesheet stop the application booting" do
      path = write("app/assets/stylesheets/application.bootstrap.scss", "")
      allow(File).to receive(:read).with(path.to_s).and_raise(Errno::EACCES)

      expect(described_class.dead_asset_references(path.to_s)).to eq []
    end
  end

  describe ".warn_about_layouts" do
    it "reports everything the installed 5.x layout has to change, as one warning" do
      write("app/views/layouts/blacklight/base.html.erb", <<~ERB)
        <%= vite_client_tag %>
        <%= render partial: 'shared/header_navbar' %>
      ERB

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /base\.html\.erb needs these changes before GeoBlacklight 6: .*shared\/header_navbar.*; .*vite_client_tag/m
      )

      described_class.warn_about_layouts(root)
    end

    it "stays quiet for a layout that has already been migrated" do
      write("app/views/layouts/blacklight/base.html.erb",
        "<%= render blacklight_config.header_component.new %>")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_layouts(root)
    end

    it "stays quiet when the application has no layout of its own" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_layouts(root)
    end

    it "never lets an unreadable layout stop the application booting" do
      path = write("app/views/layouts/application.html.erb", "")
      allow(File).to receive(:read).with(path.to_s).and_raise(Errno::EACCES)

      expect(described_class.dead_layout_references(path.to_s)).to eq []
    end
  end

  describe ".warn_about_removed_constants" do
    it "reports every removed name in a file as one warning" do
      write("app/components/document_component.html.erb", <<~ERB)
        <%= render Geoblacklight::AttributeTableComponent.new(document:) %>
        <%= render Geoblacklight::IndexMapInspectComponent.new(document:) %>
      ERB

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /document_component\.html\.erb needs these changes before GeoBlacklight 6: .*AttributeTableComponent.*; .*IndexMapInspectComponent/m
      )

      described_class.warn_about_removed_constants(root)
    end

    it "catches the renamed relations namespace without catching its replacement" do
      write("app/models/thing.rb", "Geoblacklight::Relation::RelationResponse.new(id, repo)")
      write("app/models/other.rb", "Geoblacklight::Relations::RelationResponse.new(id, repo)")

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(/app\/models\/thing\.rb/)

      described_class.warn_about_removed_constants(root)
    end

    it "looks at initializers and lib as well as app" do
      write("config/initializers/geoblacklight.rb", "Geoblacklight::ShapefileDownload")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/config\/initializers\/geoblacklight\.rb/)

      described_class.warn_about_removed_constants(root)
    end

    it "does not report the facet component the CatalogController check already covers" do
      write("app/controllers/catalog_controller.rb", "item_component: Geoblacklight::IconFacetItemComponent")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_removed_constants(root)
    end

    it "stays quiet for an application that names none of them" do
      write("app/models/solr_document.rb", "include Geoblacklight::SolrDocument")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_removed_constants(root)
    end

    it "never lets an unreadable file stop the application booting" do
      path = write("app/models/thing.rb", "")
      allow(File).to receive(:read).with(path.to_s).and_raise(Errno::EACCES)

      expect(described_class.removed_constants_in(path.to_s)).to eq []
    end
  end

  describe ".warn_about_frontend_package" do
    it "warns while the frontend package is still pinned to a 5.x release" do
      write("package.json", '{"dependencies": {"@geoblacklight/frontend": "5.3.0"}}')

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /package\.json pins @geoblacklight\/frontend to 5\.3\.0/
      )

      described_class.warn_about_frontend_package(root)
    end

    it "stays quiet once the package is on 6" do
      write("package.json", '{"dependencies": {"@geoblacklight/frontend": "^6.0.0"}}')

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_frontend_package(root)
    end

    it "stays quiet when the package is not a dependency" do
      write("package.json", '{"dependencies": {}}')

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_frontend_package(root)
    end

    it "stays quiet when there is no package.json" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_frontend_package(root)
    end

    it "ignores a package.json it cannot parse" do
      write("package.json", "{not json")

      expect(Geoblacklight.deprecation).not_to receive(:warn)
      expect { described_class.warn_about_frontend_package(root) }.not_to raise_error
    end
  end

  describe ".warn_about_locale_keys" do
    it "reports a whole key family as one line rather than one line per key" do
      write("config/locales/geoblacklight.en.yml", <<~YAML)
        en:
          blacklight:
            icon:
              stanford: Stanford
              harvard: Harvard
      YAML

      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /stop translating the 2 blacklight\.icon\.\* keys/
      )

      described_class.warn_about_locale_keys(root)
    end

    it "names a single key on its own" do
      write("config/locales/gbl.en.yml", "en:\n  geoblacklight:\n    relations:\n      browse_all: Browse\n")

      expect(Geoblacklight.deprecation).to receive(:warn).with(
        /stop translating geoblacklight\.relations\.browse_all/
      )

      described_class.warn_about_locale_keys(root)
    end

    it "reports labels that become pluralized" do
      write("config/locales/gbl.en.yml", <<~YAML)
        en:
          geoblacklight:
            relations:
              member_of_ancestors: Belongs to collection
      YAML

      expect(Geoblacklight.deprecation).to receive(:warn).with(/a one:\/other: pair/)

      described_class.warn_about_locale_keys(root)
    end

    it "matches a translation into any locale, not just English" do
      write("config/locales/gbl.de.yml", "de:\n  geoblacklight:\n    relations:\n      browse_all: Alle\n")

      expect(Geoblacklight.deprecation).to receive(:warn).with(/browse_all/)

      described_class.warn_about_locale_keys(root)
    end

    it "does not warn about translations GeoBlacklight 6 keeps" do
      write("config/locales/gbl.en.yml", "en:\n  geoblacklight:\n    home:\n      title: My Portal\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end

    it "does not warn when the application has no locale files of its own" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end

    it "ignores a locale file it cannot parse" do
      write("config/locales/broken.en.yml", "en:\n  geoblacklight:\n   : not valid: [\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)
      expect { described_class.warn_about_locale_keys(root) }.not_to raise_error
    end

    it "ignores a locale file that is not a mapping" do
      write("config/locales/scalar.en.yml", "--- just a string\n")

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_locale_keys(root)
    end
  end

  describe ".warn_about_settings_file" do
    it "reports everything the settings file needs, as one warning" do
      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /\Aconfig\/settings\.yml needs these changes before GeoBlacklight 6: /
      )

      described_class.warn_about_settings_file
    end

    it "stays quiet once there is nothing left to change" do
      allow(described_class).to receive(:settings_problems).and_return([])

      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_settings_file
    end
  end

  describe ".settings_problems" do
    subject(:problems) { described_class.settings_problems }

    it "flags the RELATIONSHIPS_SHOWN attribute GeoBlacklight 6 refuses" do
      expect(problems).to include(/remove the icon attribute from RELATIONSHIPS_SHOWN/)
    end

    it "flags uppercase RELATIONSHIPS_SHOWN entry names" do
      expect(problems).to include(/rename the 12 RELATIONSHIPS_SHOWN entries to lowercase/)
    end

    it "flags the uppercase top level key convention, and the files that read it" do
      expect(problems).to include(/rename the \d+ uppercase top level keys to lowercase/)
      expect(problems).to include(/app\/models\/solr_document\.rb/)
    end

    it "flags settings GeoBlacklight 6 stops reading" do
      expect(problems).to include(/remove Settings\.TIMEOUT_DOWNLOAD/)
    end

    it "flags a setting that is still the GeoBlacklight 5 default" do
      stub_const("#{described_class}::CHANGED_SETTINGS", {
        "TIMEOUT_WMS" => {from: Settings.TIMEOUT_WMS, to: 99, because: "of a reason"}
      })

      expect(problems).to include(/Settings\.TIMEOUT_WMS is still the GeoBlacklight 5 default/)
    end

    it "flags a setting GeoBlacklight 6 requires that is missing" do
      stub_const("#{described_class}::REQUIRED_SETTINGS", {"NO_SUCH_SETTING" => "of a reason"})

      expect(problems).to include(/set Settings\.NO_SUCH_SETTING/)
    end

    it "flags a setting value that stops matching" do
      stub_const("#{described_class}::STALE_SETTING_VALUES", {
        "METADATA_SHOWN" => {value: Settings.METADATA_SHOWN.first, because: "of a reason"}
      })

      expect(problems).to include(/Settings\.METADATA_SHOWN lists/)
    end
  end

  describe ".relationships_shown_problems" do
    it "is empty for a configuration GeoBlacklight 6 accepts" do
      migrated = Config::Options.new.merge!(
        member_of_ancestors: {field: "pcdm_memberOf_sm", inverse: "member_of_descendants",
                              label: "a.label", query_type: "ancestors"}
      )
      allow(Settings).to receive(:RELATIONSHIPS_SHOWN).and_return(migrated)

      expect(described_class.relationships_shown_problems).to be_empty
    end

    it "is empty when nothing is configured" do
      allow(Settings).to receive(:RELATIONSHIPS_SHOWN).and_return(Config::Options.new)

      expect(described_class.relationships_shown_problems).to be_empty
    end

    it "is empty when the setting is not a mapping at all" do
      allow(Settings).to receive(:RELATIONSHIPS_SHOWN).and_return(nil)

      expect(described_class.relationships_shown_problems).to be_empty
    end
  end

  describe ".uppercase_convention_problems" do
    it "is empty once every top level key is lowercase" do
      allow(Settings).to receive(:to_h).and_return({institution: "Stanford"})

      expect(described_class.uppercase_convention_problems).to be_empty
    end
  end

  describe ".warn_about_catalog_controller" do
    it "reports everything the CatalogController needs, as one warning" do
      expect(Geoblacklight.deprecation).to receive(:warn).once.with(
        /\Aapp\/controllers\/catalog_controller\.rb needs these changes before GeoBlacklight 6: /
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

    it "flags the removed facet item component" do
      expect(problems).to include(/item_component: Geoblacklight::IconFacetItemComponent/)
    end

    it "flags each removed helper the controller still names" do
      expect(problems).to include(/helper_method: :snippit/)
      expect(problems).to include(/helper_method: :render_value_as_truncate_abstract/)
    end

    # The basemap examples set the value explicitly rather than reading whatever
    # CatalogController happens to carry: blacklight_config is memoized and shared,
    # so an ambient read couples these to suite ordering.
    it "leaves the stock basemap alone" do
      config = CatalogController.blacklight_config.deep_copy
      config.basemap_provider = "positron"
      controller = class_double(CatalogController, blacklight_config: config)

      expect(described_class.catalog_controller_problems(controller))
        .not_to include(/basemap_provider/)
    end

    it "leaves an unset basemap alone" do
      config = CatalogController.blacklight_config.deep_copy
      config.basemap_provider = nil
      controller = class_double(CatalogController, blacklight_config: config)

      expect(described_class.catalog_controller_problems(controller))
        .not_to include(/basemap_provider/)
    end

    it "flags a basemap the application chose for itself" do
      config = CatalogController.blacklight_config.deep_copy
      config.basemap_provider = "darkMatter"
      controller = class_double(CatalogController, blacklight_config: config)

      expect(described_class.catalog_controller_problems(controller))
        .to include(/config\.basemap_provider = "darkMatter"/)
    end

    it "is empty for a controller that has already been migrated" do
      config = CatalogController.blacklight_config.deep_copy
      config.facet_fields.each_value { |field| field.item_component = nil }
      config.index_fields.each_value { |field| field.helper_method = nil }
      config.show_fields.each_value { |field| field.helper_method = nil }
      config.basemap_provider = "positron"
      controller = class_double(CatalogController, blacklight_config: config)

      expect(described_class.catalog_controller_problems(controller)).to be_empty
    end
  end

  describe ".setting_value" do
    it "returns the value of a top level setting" do
      expect(described_class.setting_value("TIMEOUT_WMS")).to eq Settings.TIMEOUT_WMS
    end

    it "walks a dotted path" do
      expect(described_class.setting_value("FIELDS.ID")).to eq Settings.FIELDS.ID
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
      expect(described_class.setting_present?("TIMEOUT_WMS")).to be true
    end

    it "is false for a setting that is absent" do
      expect(described_class.setting_present?("NO_SUCH_SETTING")).to be false
    end
  end

  describe ".gem_requirement_problems" do
    it "flags Blacklight 8, which GeoBlacklight 6 will not run against" do
      problems = described_class.gem_requirement_problems("Blacklight" => "8.12.3")

      expect(problems).to include(/Blacklight 8\.12\.3 is too old .* requires Blacklight 9\.0 or later/)
    end

    it "flags a Rails older than 8" do
      problems = described_class.gem_requirement_problems("Rails" => "7.2.3")

      expect(problems).to include(/Rails 7\.2\.3 is too old/)
    end

    it "is quiet once both libraries are new enough" do
      problems = described_class.gem_requirement_problems(
        "Blacklight" => "9.0.0", "Rails" => "8.1.1"
      )

      expect(problems).to be_empty
    end

    it "treats the minimum itself as new enough" do
      problems = described_class.gem_requirement_problems("Blacklight" => "9.0")

      expect(problems).to be_empty
    end

    it "says nothing about a library it cannot see" do
      expect(described_class.gem_requirement_problems({})).to be_empty
    end

    it "says nothing about a version it cannot parse" do
      problems = described_class.gem_requirement_problems("Blacklight" => "not-a-version")

      expect(problems).to be_empty
    end
  end

  describe ".current_gem_versions" do
    it "reads the versions actually loaded" do
      expect(described_class.current_gem_versions)
        .to include("Blacklight" => Blacklight::VERSION, "Rails" => Rails::VERSION::STRING)
    end
  end

  describe ".warn_about_gem_requirements" do
    it "warns once per library that is too old" do
      expect(Geoblacklight.deprecation).to receive(:warn).once.with(/Blacklight 8\.12\.3 is too old/)

      described_class.warn_about_gem_requirements("Blacklight" => "8.12.3")
    end

    it "stays quiet when every requirement is met" do
      expect(Geoblacklight.deprecation).not_to receive(:warn)

      described_class.warn_about_gem_requirements("Blacklight" => "9.0.0", "Rails" => "8.1.1")
    end

    it "reads the loaded versions when given nothing" do
      allow(described_class).to receive(:current_gem_versions).and_return("Rails" => "7.2.3")
      expect(Geoblacklight.deprecation).to receive(:warn).once.with(/Rails 7\.2\.3 is too old/)

      described_class.warn_about_gem_requirements
    end
  end

  describe ".warn!" do
    it "runs every check" do
      %i[warn_about_templates warn_about_locale_keys warn_about_routes
        warn_about_asset_references warn_about_frontend_package
        warn_about_removed_constants warn_about_layouts].each do |check|
        expect(described_class).to receive(check).with(root)
      end
      expect(described_class).to receive(:warn_about_settings_file)
      expect(described_class).to receive(:warn_about_catalog_controller)
      expect(described_class).to receive(:warn_about_gem_requirements)

      described_class.warn!(root)
    end

    it "skips the file checks when there is no application root" do
      expect(described_class).not_to receive(:warn_about_templates)
      allow(described_class).to receive(:warn_about_settings_file)
      allow(described_class).to receive(:warn_about_catalog_controller)
      allow(described_class).to receive(:warn_about_gem_requirements)

      described_class.warn!(nil)
    end
  end
end
