module Geoblacklight
  class Configuration
    # Builds a configuration from legacy (uppercase) settings
    class LegacySettingsBuilder
      def self.build
        new.build
      end

      def initialize
        @configuration = Configuration.new
      end

      def build
        @configuration.tap do |config|
          assign(config, :arcgis_base_url, Settings.ARCGIS_BASE_URL)
          assign(config, :bbox_within_boost, Settings.BBOX_WITHIN_BOOST)
          assign(config, :overlap_ratio_boost, Settings.OVERLAP_RATIO_BOOST)
          assign(config, :display_notes_shown, build_display_notes)
          assign(config, :institution, Settings.INSTITUTION)
          assign(config, :help_text, Settings.HELP_TEXT&.to_h)
          assign(config, :sidebar_static_map, Settings.SIDEBAR_STATIC_MAP)
          assign(config, :iiif_drag_drop_link, Settings.IIIF_DRAG_DROP_LINK)
          assign(config, :homepage_map_geom, Settings.HOMEPAGE_MAP_GEOM)
          assign(config, :vector_download_formats, Settings.DOWNLOAD_FORMATS&.VECTOR)
          assign(config, :metadata_shown, Settings.METADATA_SHOWN)
          assign(config, :webservices_shown, Settings.WEBSERVICES_SHOWN)
          assign(config, :relationships_shown, build_relationships)
          assign(config, :timeout_download, Settings.TIMEOUT_DOWNLOAD)
          assign(config, :download_path, Settings.DOWNLOAD_PATH)
          assign(config, :gbl_params, Settings.GBL_PARAMS)
          assign(config, :wms_params, Settings.WMS_PARAMS&.to_h)
          assign(config, :timeout_wms, Settings.TIMEOUT_WMS)

          build_fields(config)
          build_leaflet_options(config)
        end
      end

      private

      # Assigns the value to the target's attribute unless it is nil, so that
      # missing settings do not overwrite the defaults provided by Configuration.
      def assign(target, attribute, value)
        target.public_send("#{attribute}=", value) unless value.nil?
      end

      def build_display_notes
        Settings.DISPLAY_NOTES_SHOWN&.to_h&.transform_values do |value|
          DisplayNoteShownConfig.new(value.to_h)
        end
      end

      def build_relationships
        RelationshipsConfig.new(Settings.RELATIONSHIPS_SHOWN.to_h) if Settings.RELATIONSHIPS_SHOWN
      end

      def build_leaflet_options(config)
        return unless Settings.LEAFLET

        assign(config.leaflet_options, :bounds_overlay, Settings.LEAFLET.BOUNDSOVERLAY&.to_h)
        assign(config.leaflet_options, :selected_color, Settings.LEAFLET.SELECTED_COLOR)
        assign(config.leaflet_options, :sleep, Settings.LEAFLET.SLEEP&.to_h&.transform_keys(&:downcase))
        assign(config.leaflet_options, :sidebar, Settings.LEAFLET.SIDEBAR)
        assign(config.leaflet_options, :layers, Settings.LEAFLET.LAYERS&.to_h&.transform_keys(&:downcase))
      end

      def build_fields(config)
        return unless Settings.FIELDS

        assign(config.fields, :access_rights, Settings.FIELDS.ACCESS_RIGHTS)
        assign(config.fields, :alternative_title, Settings.FIELDS.ALTERNATIVE_TITLE)
        assign(config.fields, :centroid, Settings.FIELDS.CENTROID)
        assign(config.fields, :creator, Settings.FIELDS.CREATOR)
        assign(config.fields, :date_issued, Settings.FIELDS.DATE_ISSUED)
        assign(config.fields, :date_range, Settings.FIELDS.DATE_RANGE)
        assign(config.fields, :description, Settings.FIELDS.DESCRIPTION)
        assign(config.fields, :display_note, Settings.FIELDS.DISPLAY_NOTE)
        assign(config.fields, :format, Settings.FIELDS.FORMAT)
        assign(config.fields, :file_size, Settings.FIELDS.FILE_SIZE)
        assign(config.fields, :georeferenced, Settings.FIELDS.GEOREFERENCED)
        assign(config.fields, :id, Settings.FIELDS.ID)
        assign(config.fields, :identifier, Settings.FIELDS.IDENTIFIER)
        assign(config.fields, :index_year, Settings.FIELDS.INDEX_YEAR)
        assign(config.fields, :is_part_of, Settings.FIELDS.IS_PART_OF)
        assign(config.fields, :is_replaced_by, Settings.FIELDS.IS_REPLACED_BY)
        assign(config.fields, :theme, Settings.FIELDS.THEME)
        assign(config.fields, :keyword, Settings.FIELDS.KEYWORD)
        assign(config.fields, :language, Settings.FIELDS.LANGUAGE)
        assign(config.fields, :license, Settings.FIELDS.LICENSE)
        assign(config.fields, :member_of, Settings.FIELDS.MEMBER_OF)
        assign(config.fields, :metadata_version, Settings.FIELDS.METADATA_VERSION)
        assign(config.fields, :modified, Settings.FIELDS.MODIFIED)
        assign(config.fields, :overlap_field, Settings.FIELDS.OVERLAP_FIELD)
        assign(config.fields, :publisher, Settings.FIELDS.PUBLISHER)
        assign(config.fields, :provider, Settings.FIELDS.PROVIDER)
        assign(config.fields, :references, Settings.FIELDS.REFERENCES)
        assign(config.fields, :relation, Settings.FIELDS.RELATION)
        assign(config.fields, :replaces, Settings.FIELDS.REPLACES)
        assign(config.fields, :resource_class, Settings.FIELDS.RESOURCE_CLASS)
        assign(config.fields, :resource_type, Settings.FIELDS.RESOURCE_TYPE)
        assign(config.fields, :rights, Settings.FIELDS.RIGHTS)
        assign(config.fields, :rights_holder, Settings.FIELDS.RIGHTS_HOLDER)
        assign(config.fields, :source, Settings.FIELDS.SOURCE)
        assign(config.fields, :spatial_coverage, Settings.FIELDS.SPATIAL_COVERAGE)
        assign(config.fields, :geometry, Settings.FIELDS.GEOMETRY)
        assign(config.fields, :subject, Settings.FIELDS.SUBJECT)
        assign(config.fields, :suppressed, Settings.FIELDS.SUPPRESSED)
        assign(config.fields, :temporal_coverage, Settings.FIELDS.TEMPORAL_COVERAGE)
        assign(config.fields, :title, Settings.FIELDS.TITLE)
        assign(config.fields, :version, Settings.FIELDS.VERSION)
        assign(config.fields, :wxs_identifier, Settings.FIELDS.WXS_IDENTIFIER)
      end
    end
  end
end
