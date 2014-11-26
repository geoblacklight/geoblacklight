class GeotiffDownload < Download
  GEOTIFF_DOWNLOAD_PARAMS = {
    format: 'image/geotiff',
    width: 4096
  }

  def initialize(document)
    request_params = GEOTIFF_DOWNLOAD_PARAMS.merge(layers: document[:layer_id_s])
    super(document, {
      type: 'geotiff',
      extension: 'tif',
      request_params: request_params,
      content_type: 'image/geotiff',
      service_type: 'wms',
      reflect: true
    })
  end
end
