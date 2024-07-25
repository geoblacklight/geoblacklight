# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering the viewer container for the map
  #
  class ViewerContainerComponent < ViewComponent::Base
    def initialize(document:)
      super
      @document = document
      @viewer_protocol = document.viewer_protocol
    end
  end
end
