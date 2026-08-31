# frozen_string_literal: true

require "pathname"

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
      "catalog/_show_default_display_note" => "use Geoblacklight::DocumentComponent instead",
      "catalog/_show_default_viewer_container" => "use Geoblacklight::ItemMapViewerComponent instead",
      "catalog/_show_default_viewer_information" => "it is removed without replacement",
      "catalog/_show_downloads" => "use Geoblacklight::DownloadLinksComponent instead",
      "catalog/_show_header_default" => "use Geoblacklight::HeaderComponent instead",
      "catalog/_show_sidebar" => "use Geoblacklight::Document::SidebarComponent instead",
      "catalog/_show_sidebar_static_map" => "use Geoblacklight::StaticMapComponent instead",
      "catalog/_show_web_services" => "use Geoblacklight::WebServicesLinkComponent instead",
      "catalog/_web_services" => "use Geoblacklight::WebServicesComponent instead",
      "catalog/_web_services_default" => "use Geoblacklight::WebServicesDefaultComponent instead",
      "catalog/_web_services_wfs" => "use Geoblacklight::WebServicesWfsComponent instead",
      "catalog/_web_services_wms" => "use Geoblacklight::WebServicesWmsComponent instead",
      "download/hgl" => "the Harvard Geospatial Library download integration is removed without replacement",
      "relation/_relations" => "use Geoblacklight::RelationsComponent instead",
      "shared/_header_navbar" => "GeoBlacklight no longer overrides this template; override Blacklight's copy instead"
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
    # Warn about every deprecated template and setting we can see.
    # @param root [Pathname] the application root to inspect
    def self.warn!(root = Rails.root)
      warn_about_templates(root) if root
      warn_about_settings
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

    def self.warn_about_settings
      return unless defined?(::Settings)

      SETTINGS.each do |setting, advice|
        next unless setting_present?(setting)
        Geoblacklight.deprecation.warn(
          "Settings.#{setting} is deprecated and will be removed in GeoBlacklight 5; #{advice}"
        )
      end
    end

    ##
    # Walk a dotted settings path without raising when an ancestor is missing.
    # @param setting [String] e.g. "LEAFLET.VIEWERS"
    # @return [Boolean]
    def self.setting_present?(setting)
      setting.split(".").reduce(::Settings) do |node, key|
        return false unless node.respond_to?(key)
        node.public_send(key)
      end.present?
    end

    def self.relative_to(path, root)
      Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
    end
    private_class_method :relative_to
  end
end
