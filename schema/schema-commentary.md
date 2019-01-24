## Commentary

This document elaborates on the application of fields in the GeoBlacklight 1.0 Metadata Schema. For a profile of the schema, visit [here](/schema/geoblacklight-schema.md).

### Identifier

### Rights

### Title

The ideal sequence of a title is something akin to Topic of Layer, Place, Year. Putting the years at the end of a title produces better search results, since titles are left-anchored.

### Provenance

### Schema Version

### Slug

### Bounding Box

### Solr Year

### Creator

See also the comments on `dc_publisher_sm`. The `dc_creator_sm` field is best reserved for instances in which an individual person has collected, produced, or generated analyses of data. 

### Description

### Format

### Language

Most of the time the language of data is English. Other languages can be used in the case where they are represented in the attribute tables, documentation, or on the map object itself.

### Publisher

The distinction between `dc_publisher_sm` and `dc_creator_sm` is confusing, but generally, the best practice is to use the `dc_creator_sm` field only when an individual (or group of individuals) has generated a dataset from individual collection, analyses, or syntheses.

### Source

Common uses include: individual sheets within a map series can point to a Shapefile that serves as an index map; individual Shapefile layers that have been derived from a Geodatabase can point to the record for the GeoDatabase. See https://github.com/geoblacklight/geoblacklight/wiki/Using-data-relations-widget for more information.

### Subject

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
