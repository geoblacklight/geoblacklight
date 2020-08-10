# frozen_string_literal: true
module Geoblacklight
  class GeojsonDownload < Geoblacklight::Download
    GEOJSON_DOWNLOAD_PARAMS = {
      service: 'wfs',
      version: '2.0.0',
      request: 'GetFeature',
      srsName: 'EPSG:4326',
      outputformat: 'application/json'
    }.freeze

    def initialize(document, options = {})
      request_params = GEOJSON_DOWNLOAD_PARAMS.merge(typeName: document[:layer_id_s])
      super(document, {
        type: 'geojson',
        extension: 'json',
        request_params: request_params,
        content_type: 'application/json',
        service_type: 'wfs'
      }.merge(options))
    end
  end
end
