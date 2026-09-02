# frozen_string_literal: true

module Geoblacklight
  class HeaderBadgesComponent < ViewComponent::Base
    attr_reader :document

    DEFAULT_FIELDS = [
      Geoblacklight.configuration.fields.access_rights,
      Geoblacklight.configuration.fields.resource_class,
      Geoblacklight.configuration.fields.georeferenced
    ].freeze

    def initialize(document:, fields: DEFAULT_FIELDS)
      @document = document
      @fields = fields
      super()
    end

    def render_badge(field)
      render badge_class(field).new(document: @document, field:)
    end

    def badge_class(field)
      case field
      when Geoblacklight.configuration.fields.resource_class
        Geoblacklight::ResourceHeaderBadgeComponent
      when Geoblacklight.configuration.fields.georeferenced
        Geoblacklight::GeoreferencedHeaderBadgeComponent
      else
        Geoblacklight::HeaderBadgeComponent
      end
    end
  end
end
