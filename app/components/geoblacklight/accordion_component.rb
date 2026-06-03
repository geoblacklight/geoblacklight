# frozen_string_literal: true

module Geoblacklight
  class AccordionComponent < ViewComponent::Base
    def initialize(id:, title:)
      @id = id
      @title = title
      super()
    end

    def sidebar?
      Geoblacklight.configuration.leaflet_options.sidebar
    end
  end
end
