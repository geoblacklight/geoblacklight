# frozen_string_literal: true

module Geoblacklight
  module Configuration
    class LegacyLeafletSleep
      def initialize(settings)
        @settings = settings
        @sleep = settings.SLEEP
      end

      attr_accessor :sleep

      def margin_distance
        @settings.MARGIN_DISTANCE
      end

      def sleeptime
        @settings.SLEEPTIME
      end

      def waketime
        @settings.WAKETIME
      end

      def hovertowake
        @settings.HOVERTOWAKE
      end

      def message
        @settings.MESSAGE
      end

      def background
        @settings.BACKGROUND
      end
    end
  end
end
