# frozen_string_literal: true

require "pathname"
require "yaml"

module Geoblacklight
  ##
  # Boot time checks for application configuration that GeoBlacklight 5 removes.
  #
  # These cases cannot be caught by deprecating a method, because nothing in
  # GeoBlacklight calls them:
  #
  # * An overridden template keeps working on 4.x and is simply never rendered
  #   again on 5.x, so the customization disappears silently.
  # * A removed setting is only ever read by JavaScript, or by code that 5.x
  #   deletes outright.
  #
  # So we look at the application's own files and settings once, at boot.
  module DeprecatedConfiguration
    ##
    # Templates GeoBlacklight 5 no longer ships, mapped to their replacement.
    # An application that has copied one of these into app/views will keep the
    # file after upgrading, but GeoBlacklight 5 will not render it.
    TEMPLATES = {
      "catalog/_arcgis" => "use Geoblacklight::ArcgisComponent instead",
      "catalog/_carto" => "the Carto OneClick integration is removed without replacement",
      "catalog/_data_dictionary" => "use Geoblacklight::DataDictionaryDownloadComponent instead",
      "catalog/_downloads_collapse" => "use Geoblacklight::DownloadLinksComponent instead",
      "catalog/_header_icons" => "use Geoblacklight::HeaderIconsComponent instead",
      "catalog/_index_split_default" => "use Geoblacklight::SearchResultComponent instead",
      "catalog/_results_pagination" => "GeoBlacklight no longer overrides this template; override Blacklight's copy instead",
      "catalog/_show_default_attribute_table" => "use Geoblacklight::AttributeTableComponent instead",
      "catalog/_show_default_display_note" => "use Geoblacklight::DisplayNoteComponent instead",
      "catalog/_show_default_viewer_container" => "use Geoblacklight::ItemMapViewerComponent instead",
      "catalog/_show_default_viewer_information" => "it is removed without replacement",
      "catalog/_show_downloads" => "use Geoblacklight::DownloadLinksComponent instead",
      "catalog/_show_header_default" => "use the title slot of Geoblacklight::DocumentComponent instead",
      "catalog/_show_sidebar" => "use Geoblacklight::Document::SidebarComponent instead",
      "catalog/_show_sidebar_static_map" => "use Geoblacklight::StaticMapComponent instead",
      "catalog/_show_web_services" => "use Geoblacklight::WebServicesLinkComponent instead",
      "catalog/_web_services" => "use Geoblacklight::WebServicesComponent instead",
      "catalog/_web_services_default" => "use Geoblacklight::WebServicesDefaultComponent instead",
      "catalog/_web_services_wfs" => "use Geoblacklight::WebServicesWfsComponent instead",
      "catalog/_web_services_wms" => "use Geoblacklight::WebServicesWmsComponent instead",
      "download/hgl" => "the Harvard Geospatial Library download integration is removed without replacement",
      "relation/_relations" => "use Geoblacklight::RelationsComponent instead",
      "shared/_header_navbar" => "set config.header_component to a subclass of Geoblacklight::HeaderComponent instead"
    }.freeze

    ##
    # Settings keys GeoBlacklight 5 no longer reads, mapped to their replacement.
    # Each entry is the dotted path to check, e.g. "LEAFLET.VIEWERS".
    SETTINGS = {
      "APPLICATION_LOGO_URL" => "it was only used by the Carto OneClick integration, which is removed without replacement",
      "CARTO_ONECLICK_LINK" => "the Carto OneClick integration is removed without replacement",
      "LEAFLET.VIEWERS" => "viewer controls are no longer configurable per protocol"
    }.freeze

    ##
    # Settings whose default GeoBlacklight 5 changes. The installer only writes
    # config/settings.yml once, so an application upgrading from 4.x carries its
    # old value forward silently. We warn only when the value is still the 4.x
    # default, so an application that has deliberately chosen a value is left alone.
    CHANGED_SETTINGS = {
      "ARCGIS_BASE_URL" => {
        from: "https://www.arcgis.com/home/webmap/viewer.html",
        to: "https://www.arcgis.com/apps/mapviewer/index.html",
        because: "Esri retired the classic map viewer. The old URL still redirects and keeps the urls= " \
                 "parameter, so \"Open in ArcGIS\" works today; update the setting so you stop relying " \
                 "on that redirect"
      },
      "TIMEOUT_DOWNLOAD" => {
        from: 16,
        to: 180,
        because: "16 seconds is too short for many generated downloads"
      },
      "WMS_PARAMS.INFO_FORMAT" => {
        from: "text/html",
        to: "application/json",
        because: "GeoBlacklight 5 asks GetFeatureInfo for JSON. It still builds an attribute table from " \
                 "an HTML response, but marks it isHTML, so it cannot highlight the clicked feature on " \
                 "the map and cannot tell an empty result from a real one"
      }
    }.freeze

    ##
    # Individual setting values that stop matching anything in GeoBlacklight 5. These
    # are only present when an application configured them deliberately, so the check
    # is silent for a stock application.
    STALE_SETTING_VALUES = {
      "SIDEBAR_STATIC_MAP" => {
        value: "map",
        because: "Geoblacklight::StaticMapComponent will stop rendering the sidebar map for those documents"
      },
      "HELP_TEXT.viewer_protocol" => {
        value: "map",
        because: "Geoblacklight::ViewerHelpTextComponent will stop rendering help text for those documents"
      }
    }.freeze

    ##
    # Provider icon slugs that GeoBlacklight 5 renames, and routes through
    # Settings.ICON_MAPPING. It ships no label for the new name.
    ICON_RENAMES = {
      "chicago" => "university-of-chicago",
      "illinois" => "university-of-illinois-urbana-champaign",
      "iowa" => "university-of-iowa",
      "maryland" => "university-of-maryland",
      "michigan" => "university-of-michigan",
      "michigan-state" => "michigan-state-university",
      "minnesota" => "university-of-minnesota",
      "nebraska" => "university-of-nebraska-lincoln",
      "ohio-state" => "the-ohio-state-university",
      "penn-state" => "pennsylvania-state-university",
      "purdue" => "purdue-university",
      "wisconsin" => "university-of-wisconsin-madison"
    }.freeze

    ##
    # Translation keys GeoBlacklight 5 stops looking up, mapped to what happens
    # instead. An application that translated or reworded one of these keeps the
    # translation in its own locale file, where GeoBlacklight 5 never reads it again,
    # so the customization disappears with no error.
    LOCALE_KEYS = {
      "geoblacklight.citation.retrieved_from" =>
        "GeoBlacklight 5 ends a citation with the document's identifier URL, its schema.org/url reference " \
        "or the catalog URL, rather than with a translated suffix",
      "geoblacklight.tools.open_carto" =>
        "the Carto OneClick integration is removed without replacement",
      "geoblacklight.references.services_close" =>
        "GeoBlacklight 5 uses blacklight.modal.close"
    }.merge(
      %w[hgl_success hgl_request hgl_request_button hgl_close hgl_instructions hgl_email].to_h do |key|
        ["geoblacklight.download.#{key}",
          "the Harvard Geospatial Library download integration is removed without replacement"]
      end
    ).merge(
      ICON_RENAMES.to_h do |short, long|
        ["blacklight.icon.#{short}",
          "GeoBlacklight 5 routes this provider through Settings.ICON_MAPPING and looks up " \
          "blacklight.icon.#{long} instead"]
      end
    ).freeze

    ##
    # Readers that GeoBlacklight 5 declares with Blacklight's `attribute`. Those are
    # defined directly on the SolrDocument class, and a method on the class wins over
    # one from an included module, so an application concern that overrides any of
    # these silently stops taking effect and `super` no longer reaches GeoBlacklight.
    DOCUMENT_ATTRIBUTE_READERS = %w[
      display_note geom_field wxs_identifier file_format rights_field_data provider
      resource_type resource_class title creator publisher identifiers issued format
    ].freeze

    ##
    # Settings that do not exist in 4.x but that GeoBlacklight 5 requires.
    REQUIRED_SETTINGS = {
      "DOWNLOAD_FORMATS.VECTOR" => "GeoBlacklight 5 builds the vector download list from this setting instead " \
        "of hardcoding Shapefile, KMZ and GeoJSON, and Geoblacklight::References#vector_download_formats " \
        "raises NoMethodError without it"
    }.freeze

    ##
    # RELATIONSHIPS_SHOWN keys that GeoBlacklight 4.1 replaced with an
    # _ANCESTORS/_DESCENDANTS pair, mapped to the key that took over the same
    # query_type. GeoBlacklight 5 does not read the old names, so a relationship
    # configured under one is simply not displayed any more.
    #
    # config/settings.yml is only written when GeoBlacklight is first installed, so an
    # application generated by GeoBlacklight 4.0 still has the old shape unless somebody
    # reconciled the block by hand. GeoBlacklight 3.x had no RELATIONSHIPS_SHOWN at all,
    # so 4.0 is the only generation this applies to.
    RELATIONSHIP_RENAMES = {
      "MEMBER_OF" => "MEMBER_OF_ANCESTORS",
      "RELATION" => "RELATION_ANCESTORS",
      "REPLACED_BY" => "REPLACES_DESCENDANTS",
      "REPLACES" => "REPLACES_ANCESTORS",
      "VERSION_OF" => "VERSION_OF_DESCENDANTS"
    }.freeze

    ##
    # The GeoBlacklight 4 install generator injected
    # `<%= javascript_tag '$.fx.off = true;' if Rails.env.test? %>` into the
    # application layout. GeoBlacklight 5 does not ship jQuery, so the line raises
    # "$ is not defined" once the application's tests run. Nothing else reports it: the
    # layout is not one of the TEMPLATES GeoBlacklight removes, so the application keeps
    # the file and only finds out when the suite breaks.
    JQUERY_ANIMATIONS = /\$\.fx\.off/

    ##
    # Warn about every deprecated template and setting we can see.
    # @param root [Pathname] the application root to inspect
    def self.warn!(root = Rails.root)
      if root
        warn_about_templates(root)
        warn_about_helper_override(root)
        warn_about_locale_keys(root)
        warn_about_jquery_animations(root)
      end
      warn_about_settings
      warn_about_changed_settings
      warn_about_required_settings
      warn_about_stale_setting_values
      warn_about_relationship_keys
      warn_about_document_overrides
      warn_about_catalog_controller
    end

    ##
    # GeoBlacklight 5 changes GeoblacklightHelper substantially: about twenty methods
    # are removed, document_available? takes an argument, and viewer_protocol can be
    # nil. An application that has copied the helper into app/helpers shadows
    # GeoBlacklight's own, which also suppresses every method level deprecation in it,
    # so this is the only warning such an application gets.
    # @param root [Pathname] the application root to inspect
    def self.warn_about_helper_override(root)
      override = File.join(root, "app", "helpers", "geoblacklight_helper.rb")
      return unless File.exist?(override)

      Geoblacklight.deprecation.warn(
        "#{relative_to(override, root)} overrides GeoblacklightHelper, which shadows GeoBlacklight's own " \
        "copy and hides the deprecations for the helper methods GeoBlacklight 5 removes. Before upgrading: " \
        "document_available? has to accept an optional document, and viewer_protocol can return nil, so " \
        "viewer_protocol.camelize raises for a document with no viewer reference"
      )
    end

    ##
    # Show partials the 4.x install generator lists in the application's own
    # CatalogController, all of which GeoBlacklight 5 removes.
    SHOW_PARTIALS = %w[
      show_default_display_note show_default_viewer_container
      show_default_attribute_table show_default_viewer_information
    ].freeze

    ##
    # Show tools the 4.x install generator registers with `partial:`. GeoBlacklight 5
    # removes all three partials, and Blacklight 8 wants a `component:` instead.
    SHOW_TOOL_PARTIALS = %w[arcgis carto data_dictionary].freeze

    ##
    # Everything the application's own CatalogController needs before GeoBlacklight 5,
    # reported as a single to-do list. One warning per file the application has to
    # edit keeps the boot output readable: a stock 4.x app trips every one of these
    # checks, and warning separately would mean six lines on every rails, rake and
    # rspec invocation. It is also why none of this is reported from the partials
    # themselves, which would warn several times per request instead.
    def self.warn_about_catalog_controller
      return unless defined?(::CatalogController)

      problems = catalog_controller_problems(::CatalogController)
      return if problems.empty?

      Geoblacklight.deprecation.warn(
        "app/controllers/catalog_controller.rb needs these changes before GeoBlacklight 5: " +
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

      if config.index.document_presenter_class.to_s == "Geoblacklight::DocumentPresenter"
        problems << "remove `config.index.document_presenter_class = Geoblacklight::DocumentPresenter`, " \
          "because GeoBlacklight 5 removes that class and the reference will not resolve"
      end

      stale = SHOW_PARTIALS & config.show.partials.map(&:to_s)
      if stale.any?
        problems << "remove #{stale.join(", ")} from `config.show.partials`, because GeoBlacklight 5 " \
          "ships none of those partials"
      end

      if config.show.document_component.nil?
        problems << "set `config.show.document_component = Geoblacklight::DocumentComponent`, or the record " \
          "page loses the map viewer and the attribute table"
      end
      if config.index.document_component.nil?
        problems << "set `config.index.document_component = Geoblacklight::SearchResultComponent`, or search " \
          "results lose the map data attributes and the icons"
      end
      if config.header_component.to_s.start_with?("Blacklight::")
        problems << "set `config.header_component = Geoblacklight::HeaderComponent`, because GeoBlacklight 5 " \
          "renders the masthead there rather than from shared/_header_navbar"
      end

      config.show.document_actions.each do |key, action|
        next unless action.component.nil?
        next unless SHOW_TOOL_PARTIALS.include?(action.partial.to_s)
        problems << "register the #{key.inspect} show tool with a `component:` rather than " \
          "`partial: #{action.partial.to_s.inspect}`, because GeoBlacklight 5 removes that partial"
      end

      problems << web_services_problem(controller)
      problems.compact
    end

    ##
    # Blacklight 8's action_documents returns only the documents, so the 4.x
    # destructuring leaves @documents nil.
    # @param controller [Class]
    # @return [String, nil]
    def self.web_services_problem(controller)
      source = controller.instance_method(:web_services).source_location&.first
      return unless source && File.exist?(source)
      return unless File.read(source).match?(/@response\s*,\s*@documents\s*=\s*action_documents/)

      "replace `@response, @documents = action_documents` in #web_services with `@docs = action_documents`, " \
        "because Blacklight 8 returns only the documents"
    rescue
      nil
    end

    ##
    # Warn about application modules whose overrides of a SolrDocument reader stop
    # winning in GeoBlacklight 5. Only module overrides are reported: a definition in
    # the SolrDocument class body still takes precedence over the `attribute` reader.
    def self.warn_about_document_overrides
      return unless defined?(::SolrDocument)

      document = ::SolrDocument
      DOCUMENT_ATTRIBUTE_READERS.each do |reader|
        next unless document.method_defined?(reader) || document.private_method_defined?(reader)

        method = document.instance_method(reader)
        # A C implemented method is Ruby's, not the application's: Kernel#format, for
        # one, answers private_method_defined?("format") on any document class.
        next if method.source_location.nil?

        owner = method.owner
        next if owner.is_a?(Class)
        next if owner.name.to_s.start_with?("Geoblacklight", "Blacklight")

        Geoblacklight.deprecation.warn(
          "#{owner}##{reader} overrides Geoblacklight::SolrDocument##{reader}; GeoBlacklight 5 defines " \
          "that reader directly on #{document} with Blacklight's `attribute`, so an override in an " \
          "included module is ignored. Move it into the #{document} class body, after " \
          "`include Geoblacklight::SolrDocument`"
        )
      end
    rescue NameError
      nil
    end

    def self.warn_about_stale_setting_values
      return unless defined?(::Settings)

      STALE_SETTING_VALUES.each do |setting, stale|
        next unless Array(setting_value(setting)).include?(stale[:value])
        Geoblacklight.deprecation.warn(
          "Settings.#{setting} lists #{stale[:value].inspect}, which never matches in GeoBlacklight 5 " \
          "because SolrDocument#viewer_protocol returns nil rather than #{stale[:value].inspect} for a " \
          "document with no viewer reference; #{stale[:because]}"
        )
      end
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_templates(root)
      TEMPLATES.each do |template, advice|
        Dir.glob(File.join(root, "app", "views", "#{template}.*")).sort.each do |override|
          Geoblacklight.deprecation.warn(
            "#{relative_to(override, root)} overrides #{template}, which is removed in " \
            "GeoBlacklight 5; #{advice}"
          )
        end
      end
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_locale_keys(root)
      Dir.glob(File.join(root, "config", "locales", "**", "*.{yml,yaml}")).sort.each do |path|
        defined_keys = locale_keys(path)

        LOCALE_KEYS.each do |key, advice|
          next unless defined_keys.include?(key)
          Geoblacklight.deprecation.warn(
            "#{relative_to(path, root)} defines #{key}, which GeoBlacklight 5 no longer looks up; #{advice}"
          )
        end
      end
    end

    ##
    # @param root [Pathname] the application root to inspect
    def self.warn_about_jquery_animations(root)
      Dir.glob(File.join(root, "app", "views", "layouts", "**", "*.{erb,haml}")).sort.each do |layout|
        next unless disables_jquery_animations?(layout)

        Geoblacklight.deprecation.warn(
          "#{relative_to(layout, root)} turns jQuery animations off with $.fx.off, which the " \
          "GeoBlacklight 4 install generator added; GeoBlacklight 5 does not ship jQuery, so remove that " \
          "javascript_tag line or the test environment raises \"$ is not defined\""
        )
      end
    end

    ##
    # @param path [String]
    # @return [Boolean]
    def self.disables_jquery_animations?(path)
      File.file?(path) && File.read(path).match?(JQUERY_ANIMATIONS)
    rescue SystemCallError
      # An unreadable layout is somebody else's problem; a boot time diagnostic
      # must never be the reason an application fails to start.
      false
    end

    ##
    # Reported as a single warning rather than one per key. An application still on the
    # GeoBlacklight 4.0 shape trips every entry, and all of them are fixed by replacing
    # the same block of the same file.
    def self.warn_about_relationship_keys
      return unless defined?(::Settings)

      stale = RELATIONSHIP_RENAMES.select { |old, _| setting_present?("RELATIONSHIPS_SHOWN.#{old}") }
      return if stale.empty?

      Geoblacklight.deprecation.warn(
        "Settings.RELATIONSHIPS_SHOWN defines #{stale.keys.join(", ")}, which GeoBlacklight 4.1 replaced " \
        "with _ANCESTORS and _DESCENDANTS pairs; GeoBlacklight 5 does not read the old names, so those " \
        "relationships stop being displayed. Rename to #{stale.values.join(", ")}, and note that each pair's " \
        "other half is new configuration rather than a rename"
      )
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

    def self.warn_about_settings
      return unless defined?(::Settings)

      SETTINGS.each do |setting, advice|
        next unless setting_present?(setting)
        Geoblacklight.deprecation.warn(
          "Settings.#{setting} is deprecated and will be removed in GeoBlacklight 5; #{advice}"
        )
      end
    end

    def self.warn_about_changed_settings
      return unless defined?(::Settings)

      CHANGED_SETTINGS.each do |setting, change|
        next unless setting_value(setting) == change[:from]
        Geoblacklight.deprecation.warn(
          "Settings.#{setting} is set to the GeoBlacklight 4 default #{change[:from].inspect}, which is " \
          "deprecated; GeoBlacklight 5 uses #{change[:to].inspect} because #{change[:because]}"
        )
      end
    end

    def self.warn_about_required_settings
      return unless defined?(::Settings)

      REQUIRED_SETTINGS.each do |setting, advice|
        next unless setting_value(setting).nil?
        Geoblacklight.deprecation.warn(
          "Settings.#{setting} is not set; GeoBlacklight 5 requires it because #{advice}"
        )
      end
    end

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
    # @param setting [String] e.g. "LEAFLET.VIEWERS"
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
