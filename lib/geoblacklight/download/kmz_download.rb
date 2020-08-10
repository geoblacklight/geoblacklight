# frozen_string_literal: true
module Geoblacklight
  class KmzDownload < Geoblacklight::Download
    KMZ_DOWNLOAD_PARAMS = { service: 'wms',
                            version: '1.1.0',
                            request: 'GetMap',
                            srsName: 'EPSG:3857',
                            format: 'application/vnd.google-earth.kmz',
                            width: 2000, height: 2000 }.freeze

    def initialize(document, options = {})
      bbox_wsen = document.bounding_box_as_wsen.split(' ').join(', ')
      request_params = KMZ_DOWNLOAD_PARAMS.merge(layers: document[:layer_id_s], bbox: bbox_wsen)
      super(document, {
        type: 'kmz',
        extension: 'kmz',
        request_params: request_params,
        content_type: 'application/vnd.google-earth.kmz',
        service_type: 'wms'
      }.merge(options))
    end
  end
end
