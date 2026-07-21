# frozen_string_literal: true

module Geoblacklight
  class ResourceHeaderBadgeComponent < HeaderBadgeComponent
    def label
      return first_resource if resource_type_icon_missing?

      dataset_type
    end

    def icon(field)
      return resource_type_icon unless resource_type_icon_missing?
      default_resource_icon
    end

    def default_resource_icon
      helpers.geoblacklight_icon(first_resource)
    end

    def resource_type_icon_missing?
      return @resource_type_icon_missing if defined?(@resource_type_icon_missing)
      @resource_type_icon_missing = resource_type_icon.include?("icon-missing")
    end

    def resource_type_icon
      @resource_type_icon ||= helpers.geoblacklight_icon(dataset_type)
    end

    def dataset_type
      @dataset_type ||= @document.resource_type.find { |type| type.include?(" data") }&.gsub(" data", "")
    end

    def first_resource
      @first_resource ||= @document.resource_class.first
    end
  end
end
