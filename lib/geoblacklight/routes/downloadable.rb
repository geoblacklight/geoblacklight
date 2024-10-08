# frozen_string_literal: true

module Geoblacklight
  module Routes
    class Downloadable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.get "file/:id", action: "file", as: :file
      end
    end
  end
end
