# frozen_string_literal: true

module Geoblacklight
  class HeaderIconsComponent < ViewComponent::Base
    attr_reader :document, :fields

    def initialize(document:,
      fields: [Geoblacklight.configuration.fields.resource_class,
        Geoblacklight.configuration.fields.access_rights])
      @document = document
      @fields = fields
      super()
    end

    def render_badge(field)
      render badge_class(field).new(document: @document, field:)
    end

    def badge_class(field)
      if field == Geoblacklight.configuration.fields.resource_class
        Geoblacklight::ResourceHeaderBadgeComponent
      else
        Geoblacklight::HeaderBadgeComponent
      end
    end
  end
end
