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
          config.arcgis_base_url = Settings.ARCGIS_BASE_URL
          config.bbox_within_boost = Settings.BBOX_WITHIN_BOOST
          config.overlap_ratio_boost = Settings.OVERLAP_RATIO_BOOST
          config.display_notes_shown = Settings.DISPLAY_NOTES_SHOWN
          config.institution = Settings.INSTITUTION
          config.help_text = Settings.HELP_TEXT.to_h
          config.sidebar_static_map = Settings.SIDEBAR_STATIC_MAP
          config.iiif_drag_drop_link = Settings.IIIF_DRAG_DROP_LINK
          config.homepage_map_geom = Settings.HOMEPAGE_MAP_GEOM
          config.vector_download_formats = Settings.DOWNLOAD_FORMATS&.VECTOR
          config.metadata_shown = Settings.METADATA_SHOWN
          config.webservices_shown = Settings.WEBSERVICES_SHOWN
          config.relationships_shown = Settings.RELATIONSHIPS_SHOWN
          config.download_path = Settings.DOWNLOAD_PATH if Settings.DOWNLOAD_PATH
          config.gbl_params = Settings.GBL_PARAMS
          config.wms_params = Settings.WMS_PARAMS.to_h
          config.timeout_wms = Settings.TIMEOUT_WMS

          build_fields(config)
        end
      end

      private

      def build_fields(config)
        config.fields.access_rights = Settings.FIELDS.ACCESS_RIGHTS
        config.fields.alternative_title = Settings.FIELDS.ALTERNATIVE_TITLE
        config.fields.centroid = Settings.FIELDS.CENTROID
        config.fields.creator = Settings.FIELDS.CREATOR
        config.fields.date_issued = Settings.FIELDS.DATE_ISSUED
        config.fields.date_range = Settings.FIELDS.DATE_RANGE
        config.fields.description = Settings.FIELDS.DESCRIPTION
        config.fields.display_note = Settings.FIELDS.DISPLAY_NOTE
        config.fields.format = Settings.FIELDS.FORMAT
        config.fields.file_size = Settings.FIELDS.FILE_SIZE
        config.fields.georeferenced = Settings.FIELDS.GEOREFERENCED
        config.fields.id = Settings.FIELDS.ID
        config.fields.identifier = Settings.FIELDS.IDENTIFIER
        config.fields.index_year = Settings.FIELDS.INDEX_YEAR
        config.fields.is_part_of = Settings.FIELDS.IS_PART_OF
        config.fields.is_replaced_by = Settings.FIELDS.IS_REPLACED_BY
        config.fields.theme = Settings.FIELDS.THEME
        config.fields.keyword = Settings.FIELDS.KEYWORD
        config.fields.language = Settings.FIELDS.LANGUAGE
        config.fields.layer_modified = Settings.FIELDS.LAYER_MODIFIED
        config.fields.license = Settings.FIELDS.LICENSE
        config.fields.member_of = Settings.FIELDS.MEMBER_OF
        config.fields.metadata_version = Settings.FIELDS.METADATA_VERSION
        config.fields.modified = Settings.FIELDS.MODIFIED
        config.fields.overlap_field = Settings.FIELDS.OVERLAP_FIELD
        config.fields.publisher = Settings.FIELDS.PUBLISHER
        config.fields.provider = Settings.FIELDS.PROVIDER
        config.fields.references = Settings.FIELDS.REFERENCES
        config.fields.relation = Settings.FIELDS.RELATION
        config.fields.replaces = Settings.FIELDS.REPLACES
        config.fields.resource_class = Settings.FIELDS.RESOURCE_CLASS
        config.fields.resource_type = Settings.FIELDS.RESOURCE_TYPE
        config.fields.rights = Settings.FIELDS.RIGHTS
        config.fields.rights_holder = Settings.FIELDS.RIGHTS_HOLDER
        config.fields.source = Settings.FIELDS.SOURCE
        config.fields.spatial_coverage = Settings.FIELDS.SPATIAL_COVERAGE
        config.fields.geometry = Settings.FIELDS.GEOMETRY
        config.fields.subject = Settings.FIELDS.SUBJECT
        config.fields.suppressed = Settings.FIELDS.SUPPRESSED
        config.fields.temporal_coverage = Settings.FIELDS.TEMPORAL_COVERAGE
        config.fields.title = Settings.FIELDS.TITLE
        config.fields.version = Settings.FIELDS.VERSION
        config.fields.wxs_identifier = Settings.FIELDS.WXS_IDENTIFIER
      end
    end
  end
end
