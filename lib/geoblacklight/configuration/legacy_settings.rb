module Geoblacklight
  module Configuration
    class LegacySettings
      def initialize(settings)
        @settings = settings
      end

      def arcgis_base_url
        @settings.ARCGIS_BASE_URL
      end

      def bbox_within_boost
        @settings.BBOX_WITHIN_BOOST
      end

      def overlap_ratio_boost
        @settings.OVERLAP_RATIO_BOOST
      end

      def homepage_map_geom
        @settings.HOMEPAGE_MAP_GEOM
      end

      def gbl_params
        @settings.GBL_PARAMS
      end

      def fields
        @settings.FIELDS
      end

      def institution
        @settings.INSTITUTION
      end

      def metadata_shown
        @settings.METADATA_SHOWN
      end

      def timeout_download
        @settings.TIMEOUT_DOWNLOAD
      end

      def timeout_wms
        @settings.TIMEOUT_WMS
      end

      def use_geom_for_relations_icon
        @settings.USE_GEOM_FOR_RELATIONS_ICON
      end

      def webservices_shown
        @settings.WEBSERVICES_SHOWN
      end

      def display_notes_shown
        @settings.DISPLAY_NOTES_SHOWN
      end

      def relationships_shown
        @settings.RELATIONSHIPS_SHOWN
      end

      def download_formats
        @settings.DOWNLOAD_FORMATS
      end

      def wms_params
        @settings.WMS_PARAMS
      end

      def leaflet
        @leaflet ||= LegacyLeaflet.new(@settings.LEAFLET)
      end

      def help_text
        @settings.HELP_TEXT
      end

      def sidebar_static_map
        @settings.SIDEBAR_STATIC_MAP
      end

      def iiif_drag_drop_link
        @settings.IIIF_DRAG_DROP_LINK
      end

      def icon_mapping
        @settings.ICON_MAPPING
      end
    end
  end
end
