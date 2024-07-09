# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering the viewer container for the map
  #
  class ViewerContainerComponent < ViewComponent::Base
    attr_reader :document

    def initialize(viewer_protocol, display_index_map)
      @viewer_protocol = viewer_protocol
      @display_index_map = display_index_map
      super
    end

    #def render?
    #  document.restricted? && document.same_institution?
    #end
  end
end