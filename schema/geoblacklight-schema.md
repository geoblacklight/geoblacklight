## <a name="resource-layer">layer</a>


A GIS data layer. See [this example](https://github.com/OpenGeoMetadata/edu.stanford.purl/blob/master/bb/099/zb/1450/geoblacklight.json) metadata layer.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **dc_creator_sm** | *array* | Author(s) of the layer. *Optional* | `"George Washington, Thomas Jefferson"` |
| **dc_description_s** | *string* | Description for the layer. *Optional* | `"My Description"` |
| **dc_format_s** | *string* | File format for the layer, ideally using a controlled vocabulary. *Optional* | `"Shapefile, GeoTIFF, ArcGRID"` |
| **dc_identifier_s** | *string* | Unique identifier for layer as a URI. It should be globally unique across all institutions, assumed not to be end-user visible, and is usually of the form `http://institution/id`. See https://github.com/geoblacklight/geoblacklight/wiki/Schema for more detailed documentation. | `"http://purl.stanford.edu/vr593vj7147"` |
| **dc_language_s** | *string* | Language for the layer. *Optional*. Note that future versions of the schema may make this a multi-valued field. | `"English"` |
| **dc_publisher_s** | *string* | Publisher of the layer. *Optional* | `"ML InfoMap"` |
| **dc_relation_sm** | *array* | *DEPRECATED* (use `dct_isPartOf_sm`). A reference to a related resource for this layer. *Optional* | `"http://purl.stanford.edu/vr593vj7147"` |
| **dc_rights_s** | *string* | Access rights for the layer.<br/> **one of:**`"Public"` or `"Restricted"` | `"Public"` |
| **dc_source_sm** | *array* | The identity of a layer from which this layer's data was derived. *Optional* | `"stanford-vr593vj7147"` |
| **dc_subject_sm** | *array* | Subjects for the layer, preferrably in a controlled vocabulary. *Optional* | `"Census, Human settlements"` |
| **dc_title_s** | *string* | Title for the layer. | `"My Title"` |
| **dc_type_s** | *string* | Resource type of the layer, using DCMI Type Vocabulary, usually a `Dataset`. *Optional*<br/> **one of:**`"Dataset"` or `"Image"` or `"PhysicalObject"` | `"Dataset"` |
| **dct_isPartOf_sm** | *array* | Holding entity for the layer, such as the title of a collection. *Optional* | `"Village Maps of India"` |
| **dct_issued_dt** | *date-time* | Issued date for the layer, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ). *Optional* | `"2015-01-01T12:00:00Z"` |
| **dct_provenance_s** | *string* | Institution who holds the layer. | `"Stanford"` |
| **dct_references_s** | *string* | External resources that are available for the layer. The value is a JSON hash where each key is a URI for the protocol or format, and the value is the URL to the external resource. See `dct_references_s` [detailed documentation](http://geoblacklight.org/tutorial/2015/02/09/geoblacklight-overview.html). *Optional*<br/> **pattern:** `\{.*\}` | `"{ ... }"` |
| **dct_spatial_sm** | *array* | Spatial coverage and place names for the layer, preferrably in a controlled vocabulary. *Optional* | `"Paris, San Francisco"` |
| **dct_temporal_sm** | *array* | Temporal coverage for the layer, typically years or dates. Note that this field is not in a specific date format. *Optional* | `"1989, circa 2010, 2007-2009"` |
| **geoblacklight_version** | *string* | The version of the GeoBlacklight Schema to which this metadata record conforms.<br/> **one of:**`"1.0"` | `"1.0"` |
| **georss_box_s** | *string* | *DEPRECATED* (use `solr_geom`): Bounding box for the layer, as maximum values for S W N E. | `"12.6 -119.4 19.9 84.8"` |
| **georss_point_s** | *string* | *DEPRECATED* (use `georss_box_s`): Point representation for layer as y, x - i.e., centroid | `"12.6 -119.4"` |
| **layer_geom_type_s** | *string* | Geometry type for layer data, using controlled vocabulary.<br/> **one of:**`"Point"` or `"Line"` or `"Polygon"` or `"Raster"` or `"Scanned Map"` or `"Image"` or `"Mixed"` | `"Point"` |
| **layer_id_s** | *string* | The complete identifier for the layer via WMS/WFS/WCS protocol. *Optional* | `"druid:vr593vj7147"` |
| **layer_modified_dt** | *date-time* | Last modification date for the metadata record, using XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ). *Optional* | `"2015-01-01T12:00:00Z"` |
| **layer_slug_s** | *string* | Identifies a layer in human-readable keywords. Note this value is visible to the user, and used for Permalinks. The value should be alpha-numeric characters separated by dashes, and is typically of the form `institution-keyword1-keyword2`. It should also be globally unique across all institutions in *your* GeoBlacklight index. See https://github.com/geoblacklight/geoblacklight/wiki/Schema for more detailed documentation.<br/> **pattern:** `^[-a-zA-Z0-9]+$` | `"stanford-andhra-pradesh-village-boundaries"` |
| **solr_geom** | *string* | Bounding box of the layer as a ENVELOPE WKT (from the CQL standard) using coordinates in (West, East, North, South) order. Note that this field is indexed as a Solr spatial (RPT) field.<br/> **pattern:** `ENVELOPE(.*,.*,.*,.*)` | `"ENVELOPE(76.76, 84.76, 19.91, 12.62)"` |
| **solr_year_i** | *integer* | *DEPRECATED* (only used by the Blacklight range plugin, not core GeoBlacklight, and generally you want a multi-valued field here): *Derived from* `dct_temporal_sm`. Year for which layer is valid and only a single value. Note that this field is indexed as a Solr numeric field. | `"1989"` |
| **uuid** | *string* | *DEPRECATED* (use `dc_identifier_s`): Unique identifier for layer that is globally unique. | `"http://purl.stanford.edu/vr593vj7147"` |


