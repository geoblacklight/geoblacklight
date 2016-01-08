module Geoblacklight
  module Routes
    class Wms
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.post 'handle'
      end
    end
  end
end
