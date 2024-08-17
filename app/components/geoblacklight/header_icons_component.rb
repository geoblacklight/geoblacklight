# frozen_string_literal: true

module Geoblacklight
  class HeaderIconsComponent < ViewComponent::Base
    attr_reader :document, :fields

    def initialize(document:, fields: [Settings.FIELDS.RESOURCE_CLASS, Settings.FIELDS.PROVIDER, Settings.FIELDS.ACCESS_RIGHTS])
      @document = document
      @fields = fields
      super
    end

    def get_icon(field)
      icon_name = @document[field]
      if icon_name&.include?("Datasets") && @document.resource_type
        specific_icon = @document.resource_type
        specific_icon = specific_icon.is_a?(Array) ? specific_icon.first : specific_icon
        specific_icon = specific_icon&.gsub(" data", "")
        icon = geoblacklight_icon(specific_icon, classes: "svg_tooltip")
        return icon unless icon.include?("icon-missing")
      end
      icon_name = icon_name.is_a?(Array) ? icon_name.first : icon_name
      geoblacklight_icon(icon_name, classes: "svg_tooltip")
    end
  end
end
