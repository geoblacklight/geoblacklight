# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering legend for the index map
  #
  class IndexMapLegendComponent < ViewComponent::Base
    def initialize(document:)
      super
      @document = document
    end

    def render?
      @document.item_viewer.index_map
    end
  end
end
