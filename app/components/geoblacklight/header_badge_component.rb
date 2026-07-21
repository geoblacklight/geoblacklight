# frozen_string_literal: true

module Geoblacklight
  class HeaderBadgeComponent < ViewComponent::Base
    attr_reader :document, :field

    def initialize(document:, field:)
      @document = document
      @field = field
      super()
    end

    def label
      @document[field]
    end

    def icon(field)
      helpers.geoblacklight_icon(label)
    end
  end
end
