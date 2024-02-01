# frozen_string_literal: true

module Geoblacklight
  class HomepageMapComponent < ViewComponent::Base
    def initialize(basemap:, catalog_path:, leaflet_options:, map_geometry:)
      @catalog_path = catalog_path
      @map_geometry = map_geometry
      @basemap = basemap
      @leaflet_options = leaflet_options
      super
    end
  end
end
