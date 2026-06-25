# frozen_string_literal: true

module Geoblacklight
  class Configuration
    # Wraps the global +Settings+ object so that its keys can be resolved
    # case-insensitively. When a key exists in both lower- and uppercase forms
    # the lowercase value wins. Nested hash values are wrapped recursively, so
    # chained access (e.g. +settings.fields.access_rights+) resolves regardless
    # of the case used in settings.yml. Missing keys return +nil+, mirroring the
    # behavior of the underlying Config::Options object.
    class CaseInsensitiveSettings
      def initialize(settings)
        @hash = settings.to_h
      end

      def [](key)
        resolve(key)
      end

      def to_h
        @hash
      end

      def method_missing(name, *) # rubocop:disable Style/MissingRespondToMissing, Style/MethodMissingSuper
        resolve(name)
      end

      private

      def resolve(name)
        target = name.to_s.downcase
        keys = @hash.keys.select { |key| key.to_s.downcase == target }
        return nil if keys.empty?

        key = keys.find { |candidate| candidate.to_s == candidate.to_s.downcase } || keys.first
        value = @hash[key]
        value.is_a?(Hash) ? self.class.new(value) : value
      end
    end
  end
end
