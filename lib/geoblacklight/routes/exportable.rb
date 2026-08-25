# frozen_string_literal: true

module Geoblacklight
  module Routes
    class Exportable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.member do
          mapper.get "web_services"
          mapper.get "metadata"
          mapper.get "relations" => "relation#index"
          mapper.get "viewer" => "viewer_record#show"
        end
      end
    end
  end
end
