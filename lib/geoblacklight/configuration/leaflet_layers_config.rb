# frozen_string_literal: true

module Geoblacklight
  class Configuration
    class LeafletLayersConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :detect_retina, :boolean, default: true

      attr_reader :index

      def initialize(attributes = {})
        super
        self.index = attributes[:index]
      end

      def index=(values)
        @index = (values || {}).transform_values do |val|
          if val.is_a?(LayerConfig)
            val
          else
            LayerConfig.new(val)
          end
        end
      end

      def to_h
        attributes.merge({"index" => index.transform_values(&:to_h)})
      end
    end
  end
end
