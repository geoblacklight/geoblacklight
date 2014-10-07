class ShapefileDownload < Download
  SHAPEFILE_DOWNLOAD_PARAMS = { service: 'wfs', version: '2.0.0', request: 'GetFeature', srsName: 'EPSG:4326', outputformat: 'SHAPE-ZIP' }
  
  def initialize(document)
    request_params = SHAPEFILE_DOWNLOAD_PARAMS.merge(typeName: document[:layer_id_s])
    super(document, {
      type: 'shapefile',
      extension: 'zip',
      request_params: request_params,
      content_type: 'application/zip',
      service_type: :solr_wfs_url
    })
  end
end
