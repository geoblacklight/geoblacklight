# frozen_string_literal: true

module Geoblacklight
  class ArcgisComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, action:, **)
      @document = document
      super()
    end

    # Generates an ArcGIS.com viewer url with params that can open content directly
    # See: https://doc.arcgis.com/en/arcgis-online/reference/use-url-parameters.htm
    def arcgis_link
      params = URI.encode_www_form(
        urls: document.arcgis_urls
      )
      Settings.ARCGIS_BASE_URL + "?" + params
    end

    def key
      "arcgis"
    end
  end
end
