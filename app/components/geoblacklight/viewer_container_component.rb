# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering the viewer container for the map
  #
  class ViewerContainerComponent < ViewComponent::Base
    #attr_reader :document

    def initialize(document)
      @document = document
      @viewer_protocol = document.viewer_protocol
      @display_index_map = document.item_viewer.index_map
      super
    end

    #def render?
    #  document.restricted? && document.same_institution?
    #end
  end
end