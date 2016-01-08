module Geoblacklight
  module Routes
    class Downloadable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.get 'file'
        mapper.get 'hgl'
      end
    end
  end
end
