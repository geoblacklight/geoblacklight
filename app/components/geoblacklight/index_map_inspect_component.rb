# frozen_string_literal: true

module Geoblacklight
  # Renders the HTML that is dynamically populated when inspecting index maps
  class IndexMapInspectComponent < ViewComponent::Base
    def initialize(document:)
      super()
      @document = document
    end

    def render?
      @document.viewer_protocol == "index_map"
    end
  end
end
