# frozen_string_literal: true

module Geoblacklight
  class StaticMapComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, **)
      @document = document
      super()
    end

    # If there's no preview using the big map, or there is a IIIF preview that
    # is not georeferenced, we need to see where the item is located.
    def render?
      !@document.previewable? || (@document.iiif_preview? && !@document.georeferenced?)
    end

    def before_render
      @label ||= t("geoblacklight.location")
    end

    # The card is the label and the border; the map inside it is a locator, which is the viewer's own
    # component for where a single record is.
    def viewer_tag
      render Geoblacklight::LocatorMapComponent.new(document: @document)
    end
  end
end
