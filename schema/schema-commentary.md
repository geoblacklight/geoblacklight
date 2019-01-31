## Commentary and Suggestions for the GeoBlacklight 1.0 Metadata Schema

This document elaborates on the application of fields in the
GeoBlacklight 1.0 Metadata Schema with recommendations from the
GeoBlacklight community of practice.

For a profile of the schema, visit
[here](/schema/geoblacklight-schema.md).

### Identifier

This field is required, but it is not displayed in the interface. It may
be identical to the `layer_slug_s` field, or it may be related to or derived from the `layer_id_s`. This value is
ideally a persistent identifier or permalink (such as a [PURL](https://en.wikipedia.org/wiki/Persistent_uniform_resource_locator) or [Handle](https://en.wikipedia.org/wiki/Handle_System).

### Rights

This field can be set to "Public", which allows users to view and
download an item, or "Restricted", which requires a user to log in to an
authentication service. If there are additional licenses or rights
associated with a resource, administrators will have to create a custom field in the local Solr schema.

### Title

The title is the most prominent metadata field that users see when
browsing or scanning search results. Since many datasets are created
with ambiguous or non-unique titles, it may be worth the effort to
improve or enhance them. The ideal sequence of a title is something akin
to Topic of Layer: Place, Year. Putting the year at the end of a title
produces better search results, since titles are left-anchored.

### Provenance

This field indicates the institution that contributed the resource. The
current community of practice is for this field to hold the name of the
university or institution that has created the GeoBlacklight metadata
record and/or hosts the dataset. Projects are encouraged to submit their
institutional icon to the GeoBlacklight Icons repository to display with the resource.

### Schema Version

"1.0" is the current version of the GeoBlacklight schema.

### Slug

The slug makes up the URL for the resource in GeoBlacklight. If having a
readable slug is desired, it is common to use the form,
institution-keyword1-keyword2 (words or characters are separated by hyphens).

### Bounding Box

The rectangular bounding box is to aid searching with the map interface.
Although accuracy is encouraged, it may not always be necessary to to
have precise bounding coordinates. The field functions to facilitate discovery more than to indicate exact extents.

### Solr Year

This field is a four digit integer that must be inferred by the temporal
coverage or date issued of the resource. If a single record spans multiple years, choose the earliest year for the `solr_year_i` field.

### Creator

The `dc_creator_sm` field is best reserved for instances in which an
individual person has collected, produced, or generated analyses of
data (as opposed to an agency releasing a data product or resource). See also the comments on `dc_publisher_sm`.

### Description

The `dc_description_s` field is the second most prominent value that users see
when search or browsing for items. Although not required, it is strongly
recommended. If the description is minimal or lacking, it can be
improved by concatenating available metadata fields, such as title,
date, format, and place. This is a plain text field, so html code is not
supported here unless the application is customized. It is recommended to assume that discovery happens in multiple contexts (i.e., GeoBlacklight metadata may be integrated into other discovery environments), so descriptions should use complete sentences that signpost what the data object is, even though that is evident within GeoBlacklight itself.

### Format

A long list of formats is available [here.](/schema/format-values.md)
The most important thing to remember about the `dc_format_s` field is that it is
required for Download functionality. Whatever value is in the `dc_format_s`
field will show up as text in the Download widget, unless the application has local customizations.

### Language

This field is intended to indicate the language of the dataset, map,
and/or supporting documentation. The most common practice in this community
is to spell the name language out in English (e.g., "French").

### Publisher

The distinction between `dc_publisher_sm` and `dc_creator_sm` for data
is often vague. Publishers should be the administrative body or
organization that made the original resource available, regardless of
who compiled or produced the data.

### Source

The `dc_source_sm` field exists to indicate parent-child relationships between
records. Common uses include: individual sheets within a map series that
can point to a Shapefile that serves as an index map, individual
Shapefile layers that have been derived from a Geodatabase that can
point to the record for the GeoDatabase, or collection-level and related
individual layer records. See
https://github.com/geoblacklight/geoblacklight/wiki/Using-data-relations-widget for more information.

### Subject

This field is indexed as a facet by default for GeoBlacklight
applications, and it can become unwieldy when aggregating metadata
records from multiple sources. Controlled vocabularies for GIS data have
typically been expressed as ISO Topic Categories and localized thesauri,
while scanned maps are typically described with Library of Congress
Subject Headings. Even within these vocabularies, localized spellings
and abbreviations will result in considerable variations between
institutions. Institutions are encouraged to observe what terms are
commonly in use and, at the very least, strive for internal consistency
with controlled vocabularies and spellings. This facilitates easier
metadata sharing across projects, such as the repositories in
[OpenGeoMetadata](https://github.com/OpenGeoMetadata). Some institutions
choose to create custom keyword fields to hold local, unnormalized
values. It is recommended not to use Library of Congress Subject Headings to indicate the geography or spatial coverage of a dataset; instead, use the `dct_spatial_sm` field for this.

### Type

The `dc_type_s` field is optional, but it can be useful for categorizing
between datasets, scanned maps, and collections. The GeoBlacklight schema
observes the Dublin Core controlled vocabulary for [Type](/schema/type-values.md).

### Is Part Of

The `dct_isPartOf_sm` field is most often used as a way to group
collections arbitrarily. Such groupings often have meaning within local
institutions and can be shorthand for keeping like items
together. For example, the value could mark all of the items in a single
data submission, all of the items that pertain to a class that is
working with GIS data, or all of the items harvested from a specific
Open Data portal.

### Date Issued

Although the `dct_issued_s` field is optional, it is often useful when
a clear Temporal Coverage value is not present. For example, one may
want to preserve a dataset with an uncertain lineage, but there is an
indicator on a data portal on the date of last update.

### References

All of the external links for the resource are added to the `dct_references_s`
field as a serialized JSON array of key/value pairs. For example:

```
<field name="dct_references_s">
  {
    "http://schema.org/url":"http://purl.stanford.edu/bb509gh7292",
    "http://schema.org/downloadUrl":"http://stacks.stanford.edu/file/druid:bb509gh7292/data.zip",
    "http://www.loc.gov/mods/v3":"http://purl.stanford.edu/bb509gh7292.mods",
    "http://www.isotc211.org/schemas/2005/gmd/":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/iso19139.xml",
    "http://www.w3.org/1999/xhtml":"http://opengeometadata.stanford.edu/metadata/edu.stanford.purl/druid:bb509gh7292/default.html",
    "http://www.opengis.net/def/serviceType/ogc/wfs":"https://geowebservices-restricted.stanford.edu/geoserver/wfs",
    "http://www.opengis.net/def/serviceType/ogc/wms":"https://geowebservices-restricted.stanford.edu/geoserver/wms"
  }
</field>
```
See the [References controlled vocabulary](/schema/references.md) for the URIs of the keys and their recommended uses.

### Spatial Coverage

It is recommended to have at least one place name for each layer that
corresponds to the logical extent of the area of that layer. Adding
additional place names that fall within the layer should be done only if
they are topically relevant to the content of the data. If a long list of
place names is desired in the metadata for search purposes, a customized
hidden field is recommended.

### Temporal Coverage

The `dct_temporal_sm` field is multi-valued, so multiple strings can be used to indicate the time period the resource depicts, when the
data was collected, and/or when the resources was created. Examples include: “1910?”, “1800-1805”, “before 2000”. If a single dataset spans multiple years, one can add each intervening year as a discrete value (e.g., 2007,2008,2009,2010). However, a common convention is to include only the first and last year (e.g., 2007,2010 for a dataset encompassing the span of time between 2007 and 2010).

###  Geometry Type

This field helps to differentiate between vector (Point, Line, Polygon),
raster (Raster, Image), nonspatial formats (table), or a combination
(Mixed). If processing metadata from a geospatial web server, this value
may be programmatically determined. However, in many cases, it must be manually
determined. The field is tied to icons for the resource, and provides
the user with visual clues to the item. However, if the element is
troublesome or unnecessary for a particular institution, it can be
omitted. [See the controlled vocabulary.](/schema/geometry-type-values.md)

### Layer ID

The Layer ID is used to point to specific layers within a geospatial web
service. This field is not used for ArcGIS Rest Services.

### Modified Date

This value should indicate when the metadata (not the resource itself) was last modified.
