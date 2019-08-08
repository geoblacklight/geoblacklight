# External References

The field `dct_references_s` defines external services and references using the [CatInterOp](https://github.com/OSGeo/Cat-Interop) approach. The field value is a serialized JSON array of key/value pairs, with keys representing XML namespace URI's and values the URL.

Type | Reference URI | Enables in GeoBlacklight
|:---- |:------------- |:------------------------|
Web Mapping Service (WMS) | `http://www.opengis.net/def/serviceType/ogc/wms` | Layer preview, layer preview feature inspection, downloads (vector: KMZ, raster: GeoTIFF)|
Web Feature Service (WFS) | `http://www.opengis.net/def/serviceType/ogc/wfs` | Vector downloads in GeoJSON and Shapefile|
International Image Interoperability Framework (IIIF) Image API | `http://iiif.io/api/image` | Image viewer using [Leaflet-IIIF](https://github.com/mejackreed/Leaflet-IIIF)|
Direct download file | `http://schema.org/downloadUrl` | Direct file download feature|
Data dictionary / documentation download | `http://lccn.loc.gov/sh85035852` | Direct documentation download link|
Full layer description | `http://schema.org/url` | Further descriptive information about layer|
Metadata in ISO 19139 | `http://www.isotc211.org/schemas/2005/gmd/` | Structured metadata in ISO standard expressed as XML|
Metadata in FGDC | `http://www.opengis.net/cat/csw/csdgm` | Structured metadata in FGDC standard expressed as XML|
Metadata in MODS | `http://www.loc.gov/mods/v3` | Structured metadata in MODS format|
Metadata in HTML | `http://www.w3.org/1999/xhtml` | Structured metadata in any standard expressed as HTML|
ArcGIS FeatureLayer | `urn:x-esri:serviceType:ArcGIS#FeatureLayer` | Previewing of ArcGIS FeatureLayer Service|
ArcGIS TiledMapLayer | `urn:x-esri:serviceType:ArcGIS#TiledMapLayer` | Previewing of ArcGIS TiledMapLayer Service|
ArcGIS DynamicMapLayer | `urn:x-esri:serviceType:ArcGIS#DynamicMapLayer` | Previewing of ArcGIS DynamicMapLayer Service|
ArcGIS ImageMapLayer | `urn:x-esri:serviceType:ArcGIS#ImageMapLayer` | Previewing of ArcGIS ImageMapLayer Service|
Harvard Geospatial Library Email Download | `http://schema.org/DownloadAction` | Retrieve a file via email from the Harvard Geospatial Library|
OpenIndexMap | `https://openindexmaps.org` | Provide an index map preview|
oEmbed | `https://oembed.com` | Provide an object that is embeddable through an oEmbed service
