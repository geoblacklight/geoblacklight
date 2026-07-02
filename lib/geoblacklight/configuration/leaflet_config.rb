# frozen_string_literal: true

module Geoblacklight
  class Configuration
    class LeafletConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attr_accessor :bounds_overlay, :controls

      attr_reader :sleep, :layers
      # set to true to display attribute table as sidebar on map
      attribute :sidebar, :boolean, default: false
      attribute :selected_color, :string, default: "#2C7FB8"

      DEFAULT_SLEEP_CONFIG = {
        sleep: true, # set to false to disable
        margin_distance: 100, # set to zero / false if you want to disable this check
        sleeptime: 750,
        waketime: 750,
        hovertowake: false,
        background: "rgba(214, 214, 214, .7)"
      }.freeze

      # Built lazily (rather than as a frozen constant) so the sr_color_name
      # values pick up the current I18n locale each time a config is built.
      def self.default_layers_config
        {
          index: {
            DEFAULT: LayerConfig.new(
              color: "#7FCDBB",
              sr_color_name: I18n.t("geoblacklight.map.legend.colors.default")
            ),
            UNAVAILABLE: LayerConfig.new(
              color: "#EDF8B1",
              sr_color_name: I18n.t("geoblacklight.map.legend.colors.unavailable")
            ),
            SELECTED: LayerConfig.new(
              color: "#2C7FB8",
              sr_color_name: I18n.t("geoblacklight.map.legend.colors.selected")
            )
          }
        }
      end

      def initialize
        super
        @sleep = LeafletSleepConfig.new(DEFAULT_SLEEP_CONFIG)
        @layers = LeafletLayersConfig.new(self.class.default_layers_config)
      end

      def sleep=(attributes)
        @sleep = LeafletSleepConfig.new(attributes)
      end

      def layers=(attributes)
        @layers = LeafletLayersConfig.new(attributes)
      end

      def to_h
        {
          bounds_overlay: bounds_overlay,
          selected_color: selected_color,
          sleep: sleep.to_h,
          sidebar: sidebar,
          layers: layers.to_h,
          controls: controls
        }.compact
      end
    end
  end
end
