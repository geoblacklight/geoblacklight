# frozen_string_literal: true

require "json"
require "pathname"
require "yaml"

module Geoblacklight
  ##
  # Boot time checks for application configuration that GeoBlacklight 6 removes.
  #
  # These cases cannot be caught by deprecating a method, because nothing in
  # GeoBlacklight calls them:
  #
  # * An overridden template keeps working on 5.x and is simply never rendered
  #   again on 6, so the customization disappears silently.
  # * A file the install generator wrote into the application — its routes, its
  #   CatalogController, its layout — names a constant that 6 deletes, so the
  #   application, not GeoBlacklight, is what fails to boot.
  # * A removed setting is only ever read by JavaScript, or by code that 6
  #   deletes outright.
  #
  # So we look at the application's own files and settings once, at boot. Where
  # several problems live in the same file they are reported as a single warning:
  # a stock 5.x application trips all of them at once and fixes them in one pass,
  # and one line per problem is what makes a maintainer silence the deprecator.
  module DeprecatedConfiguration
    ##
    # Templates GeoBlacklight 6 no longer ships, mapped to their replacement. An
    # application that has copied one of these into app/views will keep the file
    # after upgrading, but GeoBlacklight 6 will not render it.
    TEMPLATES = {
      "catalog/_metadata" => "use Geoblacklight::MetadataComponent instead",
      "catalog/_relations_container" => "use Geoblacklight::Document::RelationsContainerComponent instead",
      "relation/index" => "the controller is renamed, so the template moves to app/views/relations/index"
    }.freeze

    ##
    # Settings keys GeoBlacklight 6 no longer reads, mapped to what happens instead.
    SETTINGS = {
      "DOWNLOAD_FORMATS" =>
        "GeoBlacklight 6 removes the generated download subsystem and never reads it. Note the 4.x " \
        "upgrade added this key because GeoBlacklight 5 required it",
      "TIMEOUT_DOWNLOAD" =>
        "GeoBlacklight 6 removes the generated download subsystem and never reads it"
    }.freeze

    ##
    # Settings whose default GeoBlacklight 6 changes. The installer only writes
    # config/settings.yml once, so an application upgrading from 5.x carries its old
    # value forward silently. We warn only when the value is still the 5.x default,
    # so an application that has deliberately chosen a value is left alone.
    CHANGED_SETTINGS = {}.freeze

    ##
    # Individual setting values that stop matching anything in GeoBlacklight 6.
    STALE_SETTING_VALUES = {}.freeze

    ##
    # Settings that do not exist in 5.x but that GeoBlacklight 6 requires.
    REQUIRED_SETTINGS = {}.freeze

    ##
    # Translation keys GeoBlacklight 6 stops looking up, keyed by prefix so that a
    # whole family is reported as one line rather than 33. An application that
    # translated or reworded any of these keeps the translation in its own locale
    # file, where GeoBlacklight 6 never reads it again, so the customization
    # disappears with no error.
    LOCALE_KEYS = {
      "blacklight.icon." =>
        "GeoBlacklight 6 restructures its icons and ships no labels under blacklight.icon",
      "geoblacklight.download." =>
        "GeoBlacklight 6 removes the generated download subsystem, so none of its strings are used",
      "geoblacklight.help_text.viewer_protocol." =>
        "GeoBlacklight 6 removes the viewer help text popovers along with ViewerHelpTextComponent",
      "geoblacklight.metadata.toggle_summary" =>
        "GeoBlacklight 6 renders metadata through Geoblacklight::MetadataComponent",
      "geoblacklight.relations.browse_all" =>
        "GeoBlacklight 6 looks up geoblacklight.relations.browse.<relationship> instead"
    }.freeze

    ##
    # Relationship labels that GeoBlacklight 6 turns from a plain string into a
    # pluralized one:/other: pair. I18n does not raise when a String is looked up
    # with a count, so an application that reworded one keeps a label that never
    # pluralizes.
    PLURALIZED_LOCALE_KEYS = %w[
      member_of_ancestors member_of_descendants part_of_ancestors part_of_descendants
      relation_ancestors relation_descendants replaces_ancestors replaces_descendants
      source_ancestors source_descendants version_of_ancestors version_of_descendants
    ].map { |key| "geoblacklight.relations.#{key}" }.freeze

    ##
    # The only attributes GeoBlacklight 6 accepts on a RELATIONSHIPS_SHOWN entry.
    # Its Geoblacklight::Configuration::RelationshipConfig is an ActiveModel, so an
    # attribute it does not declare raises ActiveModel::UnknownAttributeError while
    # the configuration is built — which happens before anything can rescue it.
    RELATIONSHIP_ATTRIBUTES = %w[field inverse label query_type].freeze

    ##
    # Helpers the 5.x install generator names with `helper_method:` in the
    # application's own CatalogController, and that GeoBlacklight 6 removes.
    REMOVED_HELPER_METHODS = {
      "snippit" => "GeoBlacklight 6 truncates index field values itself",
      "render_value_as_truncate_abstract" =>
        "use `component: Geoblacklight::MetadataDescriptionMarkdownComponent` instead"
    }.freeze

    ##
    # Paths into the @geoblacklight/frontend package that the 5.x install generator
    # wrote into the application's own stylesheets and entrypoints. GeoBlacklight 6
    # ships plain CSS rather than Sass, so these resolve to nothing and the
    # application's asset build fails rather than degrading quietly.
    ASSET_REFERENCES = {
      "@geoblacklight/frontend/app/assets/stylesheets/geoblacklight/geoblacklight" =>
        "GeoBlacklight 6 ships plain CSS instead of Sass; import " \
        "@geoblacklight/frontend/app/assets/stylesheets/geoblacklight.css instead",
      # Matches both the Vite form, which keeps the package prefix, and the importmap
      # form, which the 5.x generator rewrites to a bare path.
      "images/blacklight/logo.svg" =>
        "GeoBlacklight 6 moves the logo to images/geoblacklight/logo.svg, with " \
        "images/geoblacklight/logo-dark.svg for dark mode"
    }.freeze

    ##
    # Things the 5.x installed layout does that GeoBlacklight 6 no longer supports.
    # Only the Vite generator copies base.html.erb into the application, but apps on
    # either pipeline copy and adapt it, so match on content rather than on the path.
    LAYOUT_REFERENCES = {
      "shared/header_navbar" =>
        "GeoBlacklight 6 renders the masthead from blacklight_config.header_component and ships no " \
        "shared/_header_navbar partial",
      "vite_client_tag" =>
        "GeoBlacklight 6 drops the vite_rails dependency and ships no Vite entrypoints; move the layout to " \
        "the stylesheet and javascript tags your asset pipeline provides"
    }.freeze

    ##
    # Where an application keeps its layouts.
    LAYOUT_GLOBS = ["app/views/layouts/**/*.{erb,haml}"].freeze

    ##
    # Where an application keeps the asset files the install generator wrote or edited.
    ASSET_GLOBS = [
      "app/assets/stylesheets/**/*.{css,scss}",
      "app/javascript/**/*.{js,css,scss}"
    ].freeze

    ##
    # GeoBlacklight names an application will only mention if it has subclassed,
    # rendered or configured them itself, and that GeoBlacklight 6 removes or moves.
    # Every one of these raises NameError or NoMethodError rather than degrading, so
    # they are worth finding before the upgrade rather than after it.
    #
    # Geoblacklight::IconFacetItemComponent is deliberately absent: every generated
    # CatalogController names it, and #catalog_controller_problems already reports it
    # with the facets it is attached to.
    REMOVED_CONSTANTS = {
      "Geoblacklight::AccordionComponent" => "it is removed without replacement",
      "Geoblacklight::AttributeTableComponent" =>
        "the inspect table is drawn inside the <ogm-viewer> element in GeoBlacklight 6",
      "Geoblacklight::DownloadLinksComponent" => "use Geoblacklight::Document::DownloadLinksComponent",
      "Geoblacklight::IndexMapInspectComponent" =>
        "index map inspection happens inside <ogm-viewer> in GeoBlacklight 6",
      "Geoblacklight::IndexMapLegendComponent" =>
        "the legend is emitted by <ogm-viewer> in GeoBlacklight 6",
      "Geoblacklight::LocationLeafletMapComponent" =>
        "use Geoblacklight::OverviewMapComponent for many records, or " \
        "Geoblacklight::LocatorMapComponent for one",
      "Geoblacklight::RelationsComponent" => "use Geoblacklight::Relations::RelationsComponent",
      "Geoblacklight::ViewerHelpTextComponent" => "it is removed without replacement",
      "Geoblacklight::Relation::" => "the namespace is renamed to Geoblacklight::Relations::",
      "Geoblacklight::CsvDownload" => "GeoBlacklight 6 removes the generated download subsystem",
      "Geoblacklight::GeojsonDownload" => "GeoBlacklight 6 removes the generated download subsystem",
      "Geoblacklight::GeotiffDownload" => "GeoBlacklight 6 removes the generated download subsystem",
      "Geoblacklight::KmzDownload" => "GeoBlacklight 6 removes the generated download subsystem",
      "Geoblacklight::ShapefileDownload" => "GeoBlacklight 6 removes the generated download subsystem",
      "RelationController" => "it is renamed to RelationsController",
      "index_fields_display" =>
        "use Geoblacklight::SearchResultComponent#description, which renders the description as Markdown"
    }.freeze

    ##
    # Where an application keeps code that could name one of those.
    CODE_GLOBS = [
      "app/**/*.{rb,erb}",
      "config/initializers/*.rb",
      "lib/**/*.rb"
    ].freeze

    ##
    # Constants the 5.x install generator wrote into the application's own
    # config/routes.rb and that GeoBlacklight 6 deletes. The application's routes
    # file is not something GeoBlacklight rewrites on upgrade, so these raise
    # NameError while Rails draws the routes — before any of our other checks run.
    ROUTE_CONSTANTS = {
      "Geoblacklight::Routes::Downloadable" =>
        "GeoBlacklight 6 removes the generated download subsystem, so delete the `concern " \
        ":gbl_downloadable`, the `namespace :download` block and `resources :download, only: [:show]`"
    }.freeze

    ##
    # Version floors GeoBlacklight 6 raises, as {library => requirement}. Unlike
    # everything else here these are not a choice the application made, and the
    # failure does not look like a GeoBlacklight problem: bundler simply refuses to
    # resolve, or Blacklight renders facets the stylesheets no longer match.
    GEM_REQUIREMENTS = {
      "Blacklight" => {
        minimum: "9.0",
        because: "the structure of facets changed, and GeoBlacklight 6's geosearch facet and " \
          "styling are written against Blacklight 9 conventions and accordion facets"
      },
      "Rails" => {
        minimum: "8.0",
        because: "GeoBlacklight 6 drops support for earlier versions"
      }
    }.freeze

    ##
    # Warn about everything we can see, once per boot.
    # @param root [Pathname] the application root to inspect
    def self.warn!(root = Rails.root)
      if root
        warn_about_templates(root)
        warn_about_locale_keys(root)
        warn_about_routes(root)
        warn_about_asset_references(root)
        warn_about_frontend_package(root)
        warn_about_removed_constants(root)
        warn_about_layouts(root)
      end
      warn_about_settings_file
      warn_about_catalog_controller
      warn_about_gem_requirements
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_templates(root)
      TEMPLATES.each do |template, advice|
        Dir.glob(File.join(root, "app", "views", "#{template}.*")).sort.each do |override|
          Geoblacklight.deprecation.warn(
            "#{relative_to(override, root)} overrides #{template}, which is removed in " \
            "GeoBlacklight 6; #{advice}"
          )
        end
      end
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_locale_keys(root)
      Dir.glob(File.join(root, "config", "locales", "**", "*.{yml,yaml}")).sort.each do |path|
        defined_keys = locale_keys(path)
        next if defined_keys.empty?

        problems = LOCALE_KEYS.filter_map do |prefix, advice|
          matched = defined_keys.select { |key| key.start_with?(prefix) }
          next if matched.empty?

          subject = (matched.size > 1) ? "the #{matched.size} #{prefix}* keys" : matched.first
          "stop translating #{subject}, because #{advice}"
        end

        pluralized = defined_keys & PLURALIZED_LOCALE_KEYS
        if pluralized.any?
          problems << "give the #{pluralized.size} geoblacklight.relations.* #{"label".pluralize(pluralized.size)} " \
            "a one:/other: pair, because GeoBlacklight 6 looks them up with a count and a plain string " \
            "silently never pluralizes"
        end

        next if problems.empty?

        Geoblacklight.deprecation.warn(
          "#{relative_to(path, root)} needs these changes before GeoBlacklight 6: #{problems.join("; ")}"
        )
      end
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_routes(root)
      path = File.join(root, "config", "routes.rb")
      return unless File.exist?(path)

      contents = File.read(path)
      problems = ROUTE_CONSTANTS.filter_map { |constant, advice| advice if contents.include?(constant) }
      return if problems.empty?

      Geoblacklight.deprecation.warn(
        "#{relative_to(path, root)} needs these changes before GeoBlacklight 6: #{problems.join("; ")}"
      )
    rescue SystemCallError
      # An unreadable routes file is somebody else's problem; a boot time diagnostic
      # must never be the reason an application fails to start.
      nil
    end

    ##
    # The install generator pins @geoblacklight/frontend to the gem's own version, so
    # `yarn upgrade` keeps the 5.x package: every import then resolves to GeoBlacklight
    # 5 assets against GeoBlacklight 6 markup, with nothing raising.
    # @param root [Pathname] the application root to inspect
    def self.warn_about_frontend_package(root)
      path = File.join(root, "package.json")
      return unless File.exist?(path)

      pinned = JSON.parse(File.read(path)).dig("dependencies", "@geoblacklight/frontend")
      return if pinned.nil? || pinned.to_s.delete("^0-9.").to_f >= 6

      Geoblacklight.deprecation.warn(
        "#{relative_to(path, root)} pins @geoblacklight/frontend to #{pinned}; GeoBlacklight 6 needs the " \
        "matching 6.x package, and `yarn upgrade` will not cross the major on its own"
      )
    rescue JSON::ParserError, SystemCallError
      # A package.json we cannot read is not ours to complain about.
      nil
    end

    ##
    # One warning per layout, listing everything in it GeoBlacklight 6 drops.
    # @param root [Pathname] the application root to inspect
    def self.warn_about_layouts(root)
      LAYOUT_GLOBS.flat_map { |glob| Dir.glob(File.join(root, glob)) }.uniq.sort.each do |path|
        problems = dead_layout_references(path)
        next if problems.empty?

        Geoblacklight.deprecation.warn(
          "#{relative_to(path, root)} needs these changes before GeoBlacklight 6: #{problems.join("; ")}"
        )
      end
    end

    ##
    # @param path [String]
    # @return [Array<String>]
    def self.dead_layout_references(path)
      contents = File.read(path)
      LAYOUT_REFERENCES.filter_map do |reference, advice|
        "stop using #{reference}, because #{advice}" if contents.include?(reference)
      end
    rescue SystemCallError
      # An unreadable layout is somebody else's problem; a boot time diagnostic must
      # never be the reason an application fails to start.
      []
    end

    ##
    # One warning per file, listing every removed GeoBlacklight name it mentions.
    # @param root [Pathname] the application root to inspect
    def self.warn_about_removed_constants(root)
      CODE_GLOBS.flat_map { |glob| Dir.glob(File.join(root, glob)) }.uniq.sort.each do |path|
        problems = removed_constants_in(path)
        next if problems.empty?

        Geoblacklight.deprecation.warn(
          "#{relative_to(path, root)} needs these changes before GeoBlacklight 6: #{problems.join("; ")}"
        )
      end
    end

    ##
    # @param path [String]
    # @return [Array<String>]
    def self.removed_constants_in(path)
      contents = File.read(path)
      REMOVED_CONSTANTS.filter_map do |name, advice|
        "stop referring to #{name}, because #{advice}" if contents.include?(name)
      end
    rescue SystemCallError
      # An unreadable file is somebody else's problem; a boot time diagnostic must
      # never be the reason an application fails to start.
      []
    end

    ##
    # One warning per asset file, listing every dead reference in it.
    # @param root [Pathname] the application root to inspect
    def self.warn_about_asset_references(root)
      ASSET_GLOBS.flat_map { |glob| Dir.glob(File.join(root, glob)) }.uniq.sort.each do |path|
        problems = dead_asset_references(path)
        next if problems.empty?

        Geoblacklight.deprecation.warn(
          "#{relative_to(path, root)} needs these changes before GeoBlacklight 6: #{problems.join("; ")}"
        )
      end
    end

    ##
    # @param path [String]
    # @return [Array<String>]
    def self.dead_asset_references(path)
      contents = File.read(path)
      ASSET_REFERENCES.filter_map do |reference, advice|
        "stop importing #{reference}, because #{advice}" if contents.include?(reference)
      end
    rescue SystemCallError
      # An unreadable asset file is somebody else's problem; a boot time diagnostic
      # must never be the reason an application fails to start.
      []
    end

    ##
    # Everything the application's own CatalogController needs before GeoBlacklight 6,
    # reported as a single to-do list.
    def self.warn_about_catalog_controller
      return unless defined?(::CatalogController)

      problems = catalog_controller_problems(::CatalogController)
      return if problems.empty?

      Geoblacklight.deprecation.warn(
        "app/controllers/catalog_controller.rb needs these changes before GeoBlacklight 6: " +
        problems.join("; ")
      )
    rescue
      # A boot time diagnostic must never be the reason an application fails to start.
      nil
    end

    ##
    # @param controller [Class]
    # @return [Array<String>]
    def self.catalog_controller_problems(controller)
      config = controller.blacklight_config
      problems = []

      icon_facets = config.facet_fields.select do |_key, field|
        field.item_component.to_s == "Geoblacklight::IconFacetItemComponent"
      end
      if icon_facets.any?
        problems << "stop passing `item_component: Geoblacklight::IconFacetItemComponent` to " \
          "#{icon_facets.keys.join(", ")}, because GeoBlacklight 6 removes that class and the reference " \
          "will not resolve"
      end

      # index_fields and show_fields are keyed by Solr field, so the same key can
      # appear in both with different helpers; check them separately.
      {"index" => config.index_fields, "show" => config.show_fields}.each do |kind, fields|
        fields.each do |key, field|
          advice = REMOVED_HELPER_METHODS[field.helper_method.to_s]
          next unless advice
          problems << "stop passing `helper_method: :#{field.helper_method}` to the #{key} #{kind} field, " \
            "because GeoBlacklight 6 removes that helper; #{advice}"
        end
      end

      basemap = config.basemap_provider
      if basemap.present? && basemap.to_s != "positron"
        problems << "move `config.basemap_provider = #{basemap.to_s.inspect}` off the Blacklight " \
          "configuration, because GeoBlacklight 6 reads the basemap from Geoblacklight.configuration and " \
          "every map silently reverts to positron"
      end

      problems
    end

    ##
    # Warn when the application is on a version of Blacklight or Rails that
    # GeoBlacklight 6 will not run against. One warning per library, because they
    # are fixed in different lines of the Gemfile and each is its own upgrade.
    # @param versions [Hash{String=>String,nil}]
    def self.warn_about_gem_requirements(versions = current_gem_versions)
      gem_requirement_problems(versions).each do |problem|
        Geoblacklight.deprecation.warn(problem)
      end
    end

    ##
    # @return [Hash{String=>String,nil}]
    def self.current_gem_versions
      {
        "Blacklight" => (::Blacklight::VERSION if defined?(::Blacklight::VERSION)),
        "Rails" => (::Rails::VERSION::STRING if defined?(::Rails::VERSION::STRING))
      }
    end

    ##
    # @param versions [Hash{String=>String,nil}]
    # @return [Array<String>]
    def self.gem_requirement_problems(versions)
      GEM_REQUIREMENTS.filter_map do |library, requirement|
        current = versions[library]
        # An unreadable version is not evidence of a problem, so say nothing.
        next unless current && Gem::Version.correct?(current)
        next if Gem::Version.new(current) >= Gem::Version.new(requirement[:minimum])

        "#{library} #{current} is too old for GeoBlacklight 6, which requires #{library} " \
          "#{requirement[:minimum]} or later, because #{requirement[:because]}"
      end
    end

    ##
    # Everything the application's own config/settings.yml needs before
    # GeoBlacklight 6, as a single to-do list. A generated 5.x settings file trips
    # several of these at once and they are all fixed in the one file.
    def self.warn_about_settings_file
      return unless defined?(::Settings)

      problems = settings_problems
      return if problems.empty?

      Geoblacklight.deprecation.warn(
        "config/settings.yml needs these changes before GeoBlacklight 6: " + problems.join("; ")
      )
    end

    ##
    # @return [Array<String>]
    def self.settings_problems
      problems = relationships_shown_problems

      removed = SETTINGS.select { |setting, _| setting_present?(setting) }
      removed.each { |setting, advice| problems << "remove Settings.#{setting}, because #{advice}" }

      CHANGED_SETTINGS.each do |setting, change|
        next unless setting_value(setting) == change[:from]
        problems << "Settings.#{setting} is still the GeoBlacklight 5 default #{change[:from].inspect}; " \
          "GeoBlacklight 6 uses #{change[:to].inspect} because #{change[:because]}"
      end

      REQUIRED_SETTINGS.each do |setting, advice|
        next unless setting_value(setting).nil?
        problems << "set Settings.#{setting}, because #{advice}"
      end

      STALE_SETTING_VALUES.each do |setting, stale|
        next unless Array(setting_value(setting)).include?(stale[:value])
        problems << "Settings.#{setting} lists #{stale[:value].inspect}, which never matches in " \
          "GeoBlacklight 6; #{stale[:because]}"
      end

      problems.concat(uppercase_convention_problems)
      problems
    end

    ##
    # GeoBlacklight 6 resolves settings case-insensitively and prefers lowercase; an
    # uppercase key still works but makes 6 emit a deprecation for every one of them.
    # Renaming is not safe on its own, because the generated CatalogController and
    # SolrDocument read Settings.UPPERCASE directly.
    # @return [Array<String>]
    def self.uppercase_convention_problems
      uppercase = ::Settings.to_h.keys.map(&:to_s).select { |key| key.match?(/[A-Z]/) }
      return [] if uppercase.empty?

      ["rename the #{uppercase.size} uppercase top level keys to lowercase, because GeoBlacklight 6 " \
        "resolves settings case-insensitively and warns once per uppercase key it has to fall back to; " \
        "convert the Settings.UPPERCASE reads in app/controllers/catalog_controller.rb and " \
        "app/models/solr_document.rb in the same pass, or the application will not boot"]
    end

    ##
    # @return [Array<String>]
    def self.relationships_shown_problems
      entries = ::Settings.RELATIONSHIPS_SHOWN
      return [] unless entries.respond_to?(:to_h)
      entries = entries.to_h
      return [] if entries.empty?

      problems = []

      extra = entries.each_value.flat_map { |entry|
        entry.respond_to?(:to_h) ? entry.to_h.keys.map(&:to_s) : []
      }.uniq - RELATIONSHIP_ATTRIBUTES
      if extra.any?
        problems << "remove the #{extra.sort.join(", ")} #{"attribute".pluralize(extra.size)} from " \
          "RELATIONSHIPS_SHOWN, which GeoBlacklight 6 does not accept — its RelationshipConfig declares " \
          "only #{RELATIONSHIP_ATTRIBUTES.join(", ")}, so building the configuration raises " \
          "ActiveModel::UnknownAttributeError on boot and again on every search"
      end

      uppercase = entries.keys.map(&:to_s).select { |key| key.match?(/[A-Z]/) }
      if uppercase.any?
        problems << "rename the #{uppercase.size} RELATIONSHIPS_SHOWN entries to lowercase, because " \
          "GeoBlacklight 6 derives each browse link's translation key from the entry name and renders " \
          "\"translation missing\" for an uppercase one"
      end

      problems
    end

    ##
    # The dotted keys a locale file defines, with the leading locale dropped so that a
    # translation into any locale matches.
    # @param path [String]
    # @return [Array<String>]
    def self.locale_keys(path)
      loaded = YAML.load_file(path, aliases: true)
      return [] unless loaded.is_a?(Hash)

      loaded.each_value.flat_map { |tree| tree.is_a?(Hash) ? dotted_keys(tree) : [] }
    rescue
      # A locale file we cannot parse is not ours to complain about.
      []
    end

    ##
    # @param tree [Hash]
    # @return [Array<String>]
    def self.dotted_keys(tree, prefix = [])
      tree.flat_map do |key, value|
        path = prefix + [key.to_s]
        value.is_a?(Hash) ? dotted_keys(value, path) : [path.join(".")]
      end
    end
    private_class_method :dotted_keys

    ##
    # Walk a dotted settings path without raising when an ancestor is missing.
    # @param setting [String] e.g. "LEAFLET.VIEWERS"
    # @return [Object, nil] the value, or nil if any step of the path is missing
    def self.setting_value(setting)
      setting.split(".").reduce(::Settings) do |node, key|
        return nil unless node.respond_to?(key)
        node.public_send(key)
      end
    end

    ##
    # @param setting [String]
    # @return [Boolean]
    def self.setting_present?(setting)
      setting_value(setting).present?
    end

    def self.relative_to(path, root)
      Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
    end
    private_class_method :relative_to
  end
end
