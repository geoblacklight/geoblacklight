# frozen_string_literal: true
module Geoblacklight
  class GeotiffDownload < Geoblacklight::Download
    GEOTIFF_DOWNLOAD_PARAMS = {
      format: 'image/geotiff',
      width: 4096
    }.freeze

    def initialize(document, options = {})
      request_params = GEOTIFF_DOWNLOAD_PARAMS.merge(layers: document[:layer_id_s])
      super(document, {
        type: 'geotiff',
        extension: 'tif',
        request_params: request_params,
        content_type: 'image/geotiff',
        service_type: 'wms',
        reflect: true
      }.merge(options))
    end
  end
end
