module Geoblacklight
  class Configuration
    # Builds a configuration from default settings
    class DefaultSettingsBuilder
      def self.build
        new.build
      end

      def initialize
        @configuration = Configuration.new
      end

      def build
        @configuration
      end
    end
  end
end
