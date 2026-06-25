# frozen_string_literal: true

module Geoblacklight
  class Configuration
    # Configuration for Leaflet map layer styles.
    class LayerConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :color, :string
      attribute :weight, :integer, default: 1
      attribute :radius, :integer, default: 4
      attribute :sr_color_name, :string

      # Supports Hash-like access for backward compatibility
      # @param [Symbol, String] key
      def [](key)
        respond_to?(key) ? send(key) : nil
      end

      # Returns the attributes as a symbolized hash
      # @return [Hash]
      def to_h
        attributes.symbolize_keys
      end
    end
  end
end
