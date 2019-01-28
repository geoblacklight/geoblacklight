## Commentary

This document elaborates on the application of fields in the GeoBlacklight 1.0 Metadata Schema with recommendations from the GeoBlacklight community of practice.

For a profile of the schema, visit [here](/schema/geoblacklight-schema.md).

### Identifier

### Rights

### Title

The title is the most prominent metadata field that users see when browsing or scanning search results. Since many datasets are created with ambiguous or non-unique titles, it may be worth the effort to improve or enhance them. The ideal sequence of a title is something akin to Topic of Layer: Place, Year. Putting the years at the end of a title produces better search results, since titles are left-anchored.

### Provenance

### Schema Version

### Slug

The slug makes up the URL for the resource in GeoBlacklight. If having a readable slug is desired, it is common to use the form institution-keyword1-keyword2.

### Bounding Box

The rectangular bounding box is to aid searching with the map interface. Although accuracy is encouraged, it may not always be necessary to to have precise bounding coordinates. The field value functions more as a finding aid than to indicate exact extents.

### Solr Year

This field is a four digit integer that must be inferred by the temporal coverage or date issued of the resource.

### Creator

The `dc_creator_sm` field is best reserved for instances in which an individual person has collected, produced, or generated analyses of data. See also the comments on `dc_publisher_sm`.

### Description

### Format

### Language

This field is intended to indicate the language of the dataset, map, and/or supporting documentation. The most common practices is to spell the name language out in English. (Ex. "French")

### Publisher

The distinction between `dc_publisher_sm` and `dc_creator_sm` for data is often vague. Publishers should be the administrative body or organization that made the original resource available, regardless of who compiled or produced the data.

### Source

Common uses include: individual sheets within a map series can point to a Shapefile that serves as an index map; individual Shapefile layers that have been derived from a Geodatabase can point to the record for the GeoDatabase. See https://github.com/geoblacklight/geoblacklight/wiki/Using-data-relations-widget for more information.

### Subject

Library of Congress place name subject headings should be transferred to Spatial Coverage.

### Type

### Is Part Of

The `dct_isPartOf_sm` field is most often used as a way to group collections arbitrarily. Such groupings often have meaning within local institutions and can be used a shorthand for keeping like items together. For example, the value could mark all of the items in a single data submission, all of the items that pertain to a class that is working with GIS data, or all of the items harvested from a specific Open Data portal.

### Date Issued

Although the `dct_issued_dt` field is optional, it is often useful when a clear Temporal Coverage value is not present. For example, you may want to preserve a dataset with an uncertain lineage, but there is an indicator on a data portal on the date of last update.

### References

### Spatial Coverage

It is recommended to have at least one place name for each layer that corresponds to the logical extent of the area of that layer. Adding additional place names that fall within the layer should be done only if they are topically relevant to the content of the data.

### Temporal Coverage

###  Geometry Type

### Layer ID

### Modified Date
