module Geoblacklight
  module Configuration
    class LegacyLeaflet
      def initialize(settings)
        @settings = settings
      end

      def map
        @settings.MAP
      end

      def boundsoverlay
        @boundsoverlay ||= LegacyLeafletBoundsOverlay.new(@settings.BOUNDSOVERLAY)
      end

      def selected_color
        @settings.SELECTED_COLOR
      end

      def sleep
        @sleep ||= LegacyLeafletSleep.new(@settings.SLEEP)
      end

      def sidebar
        @settings.SIDEBAR
      end

      def layers
        @layers ||= LegacyLeafletLayers.new(@settings.LAYERS)
      end

      attr_accessor :controls
    end
  end
end
