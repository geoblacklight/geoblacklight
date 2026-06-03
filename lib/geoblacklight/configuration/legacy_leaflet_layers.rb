# frozen_string_literal: true

module Geoblacklight
  module Configuration
    class LegacyLeafletLayers
      def initialize(settings)
        @settings = settings
      end

      def detect_retina
        @settings.DETECT_RETINA
      end

      def index
        @index ||= LegacyLeafletIndex.new(@settings.INDEX)
      end
    end

    class LegacyLeafletIndex
      def initialize(settings)
        @settings = settings
      end

      def default
        @settings.DEFAULT
      end

      def unavailable
        @settings.UNAVAILABLE
      end

      def selected
        @settings.SELECTED
      end
    end
  end
end
