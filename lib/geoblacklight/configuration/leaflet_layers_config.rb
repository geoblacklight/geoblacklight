module Geoblacklight
  class Configuration
    class LeafletLayersConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :detect_retina, :boolean, default: true

      attr_accessor :index

      def initialize(attributes = {})
        super
        @index = attributes[:index]
      end

      def to_h
        attributes.merge({"index" => index})
      end
    end
  end
end
