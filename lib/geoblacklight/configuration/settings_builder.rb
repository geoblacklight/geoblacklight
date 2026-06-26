module Geoblacklight
  class Configuration
    # Builds a configuration from legacy (uppercase) settings
    class SettingsBuilder
      def self.build
        new.build
      end

      def initialize(settings: Settings)
        @configuration = Configuration.new
        @settings = CaseInsensitiveSettings.new(settings, deprecation: Geoblacklight::Deprecation)
      end

      def build
        @configuration.tap do |config|
          assign(config, :arcgis_base_url, settings.ARCGIS_BASE_URL)
          assign(config, :bbox_within_boost, settings.BBOX_WITHIN_BOOST)
          assign(config, :overlap_ratio_boost, settings.OVERLAP_RATIO_BOOST)
          assign(config, :display_notes_shown, build_display_notes)
          assign(config, :institution, settings.INSTITUTION)
          assign(config, :help_text, settings.HELP_TEXT&.to_h)
          assign(config, :sidebar_static_map, settings.SIDEBAR_STATIC_MAP)
          assign(config, :iiif_drag_drop_link, settings.IIIF_DRAG_DROP_LINK)
          assign(config, :homepage_map_geom, settings.HOMEPAGE_MAP_GEOM)
          assign(config, :vector_download_formats, settings.DOWNLOAD_FORMATS&.VECTOR)
          assign(config, :metadata_shown, settings.METADATA_SHOWN)
          assign(config, :webservices_shown, settings.WEBSERVICES_SHOWN)
          assign(config, :relationships_shown, build_relationships)
          assign(config, :timeout_download, settings.TIMEOUT_DOWNLOAD)
          assign(config, :download_path, settings.DOWNLOAD_PATH)
          assign(config, :gbl_params, settings.GBL_PARAMS)
          assign(config, :wms_params, settings.WMS_PARAMS&.to_h)
          assign(config, :timeout_wms, settings.TIMEOUT_WMS)

          build_fields(config)
          build_leaflet_options(config)
        end
      end

      private

      attr_reader :settings

      # Assigns the value to the target's attribute unless it is nil, so that
      # missing settings do not overwrite the defaults provided by Configuration.
      def assign(target, attribute, value)
        target.public_send("#{attribute}=", value) unless value.nil?
      end

      def build_display_notes
        settings.DISPLAY_NOTES_SHOWN&.to_h&.transform_values do |value|
          DisplayNoteShownConfig.new(value.to_h)
        end
      end

      def build_relationships
        RelationshipsConfig.new(settings.RELATIONSHIPS_SHOWN.to_h) if settings.RELATIONSHIPS_SHOWN
      end

      def build_leaflet_options(config)
        return unless settings.LEAFLET

        assign(config.leaflet_options, :bounds_overlay, settings.LEAFLET.BOUNDSOVERLAY&.to_h)
        assign(config.leaflet_options, :selected_color, settings.LEAFLET.SELECTED_COLOR)
        assign(config.leaflet_options, :sleep, settings.LEAFLET.SLEEP&.to_h&.transform_keys(&:downcase))
        assign(config.leaflet_options, :sidebar, settings.LEAFLET.SIDEBAR)
        assign(config.leaflet_options, :layers, settings.LEAFLET.LAYERS&.to_h&.transform_keys(&:downcase))
      end

      def build_fields(config)
        return unless settings.FIELDS

        assign(config.fields, :access_rights, settings.FIELDS.ACCESS_RIGHTS)
        assign(config.fields, :alternative_title, settings.FIELDS.ALTERNATIVE_TITLE)
        assign(config.fields, :centroid, settings.FIELDS.CENTROID)
        assign(config.fields, :creator, settings.FIELDS.CREATOR)
        assign(config.fields, :date_issued, settings.FIELDS.DATE_ISSUED)
        assign(config.fields, :date_range, settings.FIELDS.DATE_RANGE)
        assign(config.fields, :description, settings.FIELDS.DESCRIPTION)
        assign(config.fields, :display_note, settings.FIELDS.DISPLAY_NOTE)
        assign(config.fields, :format, settings.FIELDS.FORMAT)
        assign(config.fields, :file_size, settings.FIELDS.FILE_SIZE)
        assign(config.fields, :georeferenced, settings.FIELDS.GEOREFERENCED)
        assign(config.fields, :id, settings.FIELDS.ID)
        assign(config.fields, :identifier, settings.FIELDS.IDENTIFIER)
        assign(config.fields, :index_year, settings.FIELDS.INDEX_YEAR)
        assign(config.fields, :is_part_of, settings.FIELDS.IS_PART_OF)
        assign(config.fields, :is_replaced_by, settings.FIELDS.IS_REPLACED_BY)
        assign(config.fields, :theme, settings.FIELDS.THEME)
        assign(config.fields, :keyword, settings.FIELDS.KEYWORD)
        assign(config.fields, :language, settings.FIELDS.LANGUAGE)
        assign(config.fields, :license, settings.FIELDS.LICENSE)
        assign(config.fields, :member_of, settings.FIELDS.MEMBER_OF)
        assign(config.fields, :metadata_version, settings.FIELDS.METADATA_VERSION)
        assign(config.fields, :modified, settings.FIELDS.MODIFIED)
        assign(config.fields, :overlap_field, settings.FIELDS.OVERLAP_FIELD)
        assign(config.fields, :publisher, settings.FIELDS.PUBLISHER)
        assign(config.fields, :provider, settings.FIELDS.PROVIDER)
        assign(config.fields, :references, settings.FIELDS.REFERENCES)
        assign(config.fields, :relation, settings.FIELDS.RELATION)
        assign(config.fields, :replaces, settings.FIELDS.REPLACES)
        assign(config.fields, :resource_class, settings.FIELDS.RESOURCE_CLASS)
        assign(config.fields, :resource_type, settings.FIELDS.RESOURCE_TYPE)
        assign(config.fields, :rights, settings.FIELDS.RIGHTS)
        assign(config.fields, :rights_holder, settings.FIELDS.RIGHTS_HOLDER)
        assign(config.fields, :source, settings.FIELDS.SOURCE)
        assign(config.fields, :spatial_coverage, settings.FIELDS.SPATIAL_COVERAGE)
        assign(config.fields, :geometry, settings.FIELDS.GEOMETRY)
        assign(config.fields, :subject, settings.FIELDS.SUBJECT)
        assign(config.fields, :suppressed, settings.FIELDS.SUPPRESSED)
        assign(config.fields, :temporal_coverage, settings.FIELDS.TEMPORAL_COVERAGE)
        assign(config.fields, :title, settings.FIELDS.TITLE)
        assign(config.fields, :version, settings.FIELDS.VERSION)
        assign(config.fields, :wxs_identifier, settings.FIELDS.WXS_IDENTIFIER)
      end
    end
  end
end
