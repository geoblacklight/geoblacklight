# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering legend for the index map
  #
  class IndexMapLegendComponent < ViewComponent::Base
    def initialize(document:)
      super()
      @document = document
    end

    def render?
      @document.item_viewer.index_map
    end

    delegate :configuration, to: :Geoblacklight
    delegate :leaflet_options, to: :configuration

    def index_config
      @index_config ||= leaflet_options.layers.index
    end
  end
end
