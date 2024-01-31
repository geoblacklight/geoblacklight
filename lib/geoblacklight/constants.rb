# frozen_string_literal: true

module Geoblacklight
  # Module to declare application level constants and lookup hash
  module Constants
    URI = {
      download: "http://schema.org/downloadUrl",
      fgdc: "http://www.opengis.net/cat/csw/csdgm",
      geojson: "http://geojson.org/geojson-spec.html",
      html: "http://www.w3.org/1999/xhtml",
      iiif: "http://iiif.io/api/image",
      iiif_manifest: "http://iiif.io/api/presentation#manifest",
      iso19139: "http://www.isotc211.org/schemas/2005/gmd",
      mods: "http://www.loc.gov/mods/v3",
      shapefile: "http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf",
      url: "http://schema.org/url",
      wcs: "http://www.opengis.net/def/serviceType/ogc/wcs",
      wfs: "http://www.opengis.net/def/serviceType/ogc/wfs",
      wms: "http://www.opengis.net/def/serviceType/ogc/wms",
      wmts: "http://www.opengis.net/def/serviceType/ogc/wmts",
      tms: "https://wiki.osgeo.org/wiki/Tile_Map_Service_Specification",
      tilejson: "https://github.com/mapbox/tilejson-spec",
      xyz: "https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames",
      hgl: "http://schema.org/DownloadAction",
      feature_layer: "urn:x-esri:serviceType:ArcGIS#FeatureLayer",
      tiled_map_layer: "urn:x-esri:serviceType:ArcGIS#TiledMapLayer",
      dynamic_map_layer: "urn:x-esri:serviceType:ArcGIS#DynamicMapLayer",
      image_map_layer: "urn:x-esri:serviceType:ArcGIS#ImageMapLayer",
      data_dictionary: "http://lccn.loc.gov/sh85035852",
      index_map: "https://openindexmaps.org",
      oembed: "https://oembed.com",
      cog: "https://github.com/cogeotiff/cog-spec",
      pmtiles: "https://github.com/protomaps/PMTiles"
    }.freeze
  end
end
