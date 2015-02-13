class KmzDownload < Download
  KMZ_DOWNLOAD_PARAMS = { service: 'wms', version: '1.1.0', request: 'GetMap', srsName: 'EPSG:900913', format: 'application/vnd.google-earth.kmz', width: 2000, height: 2000 }
  
  def initialize(document)
    request_params = KMZ_DOWNLOAD_PARAMS.merge(layers: document[:layer_id_s], bbox: document.bounding_box_as_wsen.split(' ').join(', '))
    super(document, {
      type: 'kmz',
      extension: 'kmz',
      request_params: request_params,
      content_type: 'application/vnd.google-earth.kmz',
      service_type: 'wms'
    })
  end
end
