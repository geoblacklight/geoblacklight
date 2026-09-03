# frozen_string_literal: true

module Geoblacklight
  # A map of where one record is, beside its metadata. There is nothing to search and nothing it
  # reports back; the record's own extent is all it draws, from the same endpoint <ogm-viewer>
  # already reads its metadata from.
  class LocatorMapComponent < ViewComponent::Base
    def initialize(document:, id: "locator-map")
      @document = document
      @id = id
      super()
    end

    def viewer_tag
      tag.ogm_locator(nil, **attributes)
    end

    private

    def attributes
      {
        :id => @id,
        :class => "viewer locator-map",
        "theme" => helpers.geoblacklight_viewer_theme,
        "light-basemap" => Geoblacklight.configuration.light_basemap_url,
        "dark-basemap" => Geoblacklight.configuration.dark_basemap_url,
        "record-url" => helpers.viewer_solr_document_path(@document)
      }
    end
  end
end
