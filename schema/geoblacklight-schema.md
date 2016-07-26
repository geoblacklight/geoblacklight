# GeoBlacklight-Schema

Table View

Properties | Type | Controlled Values | Description
---------- | ---- | ------------ |-----------
**uuid** | string || Unique identifier for layer that is globally unique.
**dc\_identifier\_s** | string || Unique identifier for layer. May be same as UUID but may be an alternate identifier.
**dc\_title\_s** | string || Title for the layer.
**dc\_description\_s** | string || Description for the layer.
**dc\_rights\_s**| string | "Public", "Restricted" | Access rights for the layer.
**dct\_provenance\_s** | string || Institution who holds the layer.
**dct\_references\_s** | string || JSON hash for external resources, where each key is a URI for the protocol or format and the value is the URL to the resource.
**georss\_box\_s** | string || Bounding box as maximum values for S W N E. Example: 12.6 -119.4 19.9 84.8.
**layer\_id\_s** | string || The complete identifier for the layer via WMS/WFS/WCS protocol. Example: druid:vr593vj7147.
**layer\_geom\_type\_s** | string | "Point", "Line", "Polygon", "Raster", "Scanned Map", "Mixed" | Geometry type for layer data, using controlled vocabulary.
**layer\_modified\_dt** | string | date-time | Last modification date for the metadata record, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ).
**layer\_slug\_s** | string || Unique identifier visible to the user, used for Permalinks. Example: stanford-vr593vj7147.
**solr\_geom** | string | /ENVELOPE(.\*,.\*,.\*,.\*)/ | **Derived** from georss\_polygon\_s or georss\_box\_s. Shape of the layer as a ENVELOPE WKT using W E N S. Example: ENVELOPE(76.76, 84.76, 19.91, 12.62). Note that this field is indexed as a Solr spatial (RPT) field.
**solr\_year\_i** | integer || **Derived** from dct\_temporal\_sm. Year for which layer is valid and only a single value. Example: 1989. Note that this field is indexed as a Solr numeric field.
dc\_creator\_sm | multivalued string || Author(s). Example: George Washington, Thomas Jefferson.
dc\_format\_s | string | Shapefile, GeoTIFF, ArcGRID | File format for the layer, using a controlled vocabulary.
dc\_language\_s | string || Language for the layer. Example: English.
dc\_publisher\_s | string || Publisher. Example: ML InfoMap.
dc\_subject\_sm | multivalued string || Subjects, preferrably in a controlled vocabulary. Examples: Census, Human settlements.
dc\_type\_s | string | "Dataset", "Image", "PhysicalObject" | Resource type, using DCMI Type Vocabulary.
dct\_spatial\_sm | multivalued string || Spatial coverage and place names, perferrably in a controlled vocabulary. Example: "Paris, France".
dct\_temporal\_sm | multivalued string || Temporal coverage, typically years or dates. Example: 1989, circa 2010, 2007-2009. Note that this field is not in a specific date format.
dct\_issued\_dt | string | date-time | Issued date for the layer, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ).
dct\_isPartOf\_sm | multivalued string || Holding dataset for the layer, such as the name of a collection. Example: Village Maps of India.
georss\_point\_s | string || Point representation for layer as y, x - i.e., centroid. Example: 12.6 -119.4.
