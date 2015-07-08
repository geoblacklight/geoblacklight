module Geoblacklight
  # Module to declare application level constants and lookup hash
  module Constants
    URI = {
      download: 'http://schema.org/downloadUrl',
      fgdc: 'http://www.opengis.net/cat/csw/csdgm',
      geojson: 'http://geojson.org/geojson-spec.html',
      html: 'http://www.w3.org/1999/xhtml',
      iiif: 'http://iiif.io/api/image',
      iso19139: 'http://www.isotc211.org/schemas/2005/gmd/',
      mods: 'http://www.loc.gov/mods/v3',
      shapefile: 'http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf',
      url: 'http://schema.org/url',
      wcs: 'http://www.opengis.net/def/serviceType/ogc/wcs',
      wfs: 'http://www.opengis.net/def/serviceType/ogc/wfs',
      wms: 'http://www.opengis.net/def/serviceType/ogc/wms',
      hgl: 'http://schema.org/DownloadAction',
      mapservice: 'http://resources.arcgis.com/en/help/arcgis-rest-api#mapService',
      featureservice: 'http://resources.arcgis.com/en/help/arcgis-rest-api#featureService',
      imageservice: 'http://resources.arcgis.com/en/help/arcgis-rest-api#imageService'
    }
  end
end
