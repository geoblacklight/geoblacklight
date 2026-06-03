# frozen_string_literal: true

module Geoblacklight
  module Configuration
    class LegacyLeafletBoundsOverlay
      def initialize(settings)
        @settings = settings
      end

      def index
        @settings.INDEX
      end

      def show
        @settings.SHOW
      end

      def static_map
        @settings.STATIC_MAP
      end
    end
  end
end
