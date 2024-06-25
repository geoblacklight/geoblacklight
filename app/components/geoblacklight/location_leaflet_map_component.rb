# frozen_string_literal: true

module Geoblacklight
  class LocationLeafletMapComponent < ViewComponent::Base
    def initialize(id: "map", label: nil, data_map: "", map_geometry: nil, classes: "")
      @id = id
      @label = label
      @data_map = data_map
      @classes = classes
      @map_geometry = map_geometry || Settings.HOMEPAGE_MAP_GEOM
      super
    end

    def before_render
      @label ||= t("geoblacklight.map.label")
    end
  end
end
