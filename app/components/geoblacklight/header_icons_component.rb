# frozen_string_literal: true

module Geoblacklight
  class HeaderIconsComponent < ViewComponent::Base
    attr_reader :document, :fields

    def initialize(document:, fields: [Settings.FIELDS.RESOURCE_CLASS, Settings.FIELDS.PROVIDER, Settings.FIELDS.ACCESS_RIGHTS])
      @document = document
      @fields = fields
      super()
    end

    def icon(field)
      return resource_icon if field == Settings.FIELDS.RESOURCE_CLASS

      geoblacklight_icon(@document[field], classes: "svg_tooltip")
    end

    # If the item has a resource type of "X data" where "X" is an existing icon, use that icon
    # Otherwise just use the resource class icon
    def resource_icon
      dataset_type = @document.resource_type.find { |type| type.include?(" data") }&.gsub(" data", "")
      resource_type_icon = geoblacklight_icon(dataset_type, classes: "svg_tooltip")
      return resource_type_icon unless resource_type_icon.include?("icon-missing")

      geoblacklight_icon(@document.resource_class.first, classes: "svg_tooltip")
    end
  end
end
