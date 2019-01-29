## Commentary

This document elaborates on the application of fields in the GeoBlacklight 1.0 Metadata Schema with recommendations from the GeoBlacklight community of practice.

For a profile of the schema, visit [here](/schema/geoblacklight-schema.md).

### Identifier

This field is required, but it is not displayed in the interface. It may be identical to slug or it may be related to the layer ID. This value is ideally a persistent identifier or permalink (such as a PURL or handle).

### Rights

This field can be set to "Public", which allows users to view and download an item, or "Restricted", which requires a user to log in to an authentication service. If there are additional licenses or rights associated with a resource, a custom field will be needed.

### Title

The title is the most prominent metadata field that users see when browsing or scanning search results. Since many datasets are created with ambiguous or non-unique titles, it may be worth the effort to improve or enhance them. The ideal sequence of a title is something akin to Topic of Layer: Place, Year. Putting the years at the end of a title produces better search results, since titles are left-anchored.

### Provenance

This indicates the institution that contributed the resource. The current community of practice is for this field to hold the name of the university that has created the GeoBlacklight metadata record and/or hosts the dataset. This field is also tied to the GeoBlacklight Icons project.

### Schema Version

"1.0" is the current version of the GeoBlacklight schema.

### Slug

The slug makes up the URL for the resource in GeoBlacklight. If having a readable slug is desired, it is common to use the form institution-keyword1-keyword2.

### Bounding Box

The rectangular bounding box is to aid searching with the map interface. Although accuracy is encouraged, it may not always be necessary to to have precise bounding coordinates. The field value functions more as a finding aid than to indicate exact extents.

### Solr Year

This field is a four digit integer that must be inferred by the temporal coverage or date issued of the resource.

### Creator

The `dc_creator_sm` field is best reserved for instances in which an individual person has collected, produced, or generated analyses of data. See also the comments on `dc_publisher_sm`.

### Description

The Description field is the second most prominent value that users see when search or browsing for items. Although not required, it is strongly recommended. If the description is minimal or lacking, it can be improved by concatenating available metadata fields, such as title, date, format, and place. This is a plain text field, so html code is not supported here unless the application is customized.

### Format

A long list of formats is available [here.](schema/format-values.md) The most important thing to remember about this field is that it is required for Download functionality. Whatever value is in the Format field will show up as text in the Download widget.

### Language

This field is intended to indicate the language of the dataset, map, and/or supporting documentation. The most common practices is to spell the name language out in English. (Ex. "French")

### Publisher

The distinction between `dc_publisher_sm` and `dc_creator_sm` for data is often vague. Publishers should be the administrative body or organization that made the original resource available, regardless of who compiled or produced the data.

### Source

Common uses include: individual sheets within a map series can point to a Shapefile that serves as an index map; individual Shapefile layers that have been derived from a Geodatabase can point to the record for the GeoDatabase. See https://github.com/geoblacklight/geoblacklight/wiki/Using-data-relations-widget for more information.

### Subject

This field is indexed as a facet by default for GeoBlacklight applications, and it can become unwieldy when aggregating metadata records from multiple sources. Controlled vocabularies for GIS data has typically been expressed as ISO Topic Categories and localized thesauri, while scanned maps are typically described with Library of Congress subject headings. Even within these vocabularies, localized spellings and abbreviations will result in considerable variations between institutions. Institutions are encouraged to observe what terms are commonly in use and, at the very least, strive for internal consistency with controlled vocabularies and spellings. This facilitates easier metadata sharing across projects, such as the repositories in [OpenGeoMetadata](https://github.com/OpenGeoMetadata).

### Type

This Dublin Core field is optional, but can be useful for categorizing between datasets, scanned maps, and collections.

### Is Part Of

The `dct_isPartOf_sm` field is most often used as a way to group collections arbitrarily. Such groupings often have meaning within local institutions and can be used a shorthand for keeping like items together. For example, the value could mark all of the items in a single data submission, all of the items that pertain to a class that is working with GIS data, or all of the items harvested from a specific Open Data portal.

### Date Issued

Although the `dct_issued_dt` field is optional, it is often useful when a clear Temporal Coverage value is not present. For example, you may want to preserve a dataset with an uncertain lineage, but there is an indicator on a data portal on the date of last update.

### References

### Spatial Coverage

It is recommended to have at least one place name for each layer that corresponds to the logical extent of the area of that layer. Adding additional place names that fall within the layer should be done only if they are topically relevant to the content of the data.

### Temporal Coverage

This field can indicate the time period the resource depicts, when the data was collected, and/or when the resources was created. It is a multivalued string field that can accommodate various characters that clarify the time period. Examples: “1910?”, “1800-1805”, “before 2000”.

###  Geometry Type

This field helps to differentiate between vector (Point, Line, Polygon), raster (Raster, Image), nonspatial formats (table), or a combination (Mixed). If processing metadata from a geospatial web server, this value may be programmatically determined. In many cases, it must be manually determined. The field is tied to icons for the resource, and provides the user with visual clues to the item. However, if the element is troublesome or unnecessary for a particular institution, it can be omitted.

### Layer ID

The Layer ID is used to point to specific layers within a geospatial web service. This field is not used for ArcGIS Rest Services.

### Modified Date
