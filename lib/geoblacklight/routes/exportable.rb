module Geoblacklight
  module Routes
    class Exportable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.member do
          mapper.get 'web_services'
          mapper.get 'metadata'
        end
      end
    end
  end
end
