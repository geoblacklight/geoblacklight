## GeoBlacklight 1.0 Metadata Schema
This is an overview of the GeoBlacklight Metadata Schema, Version 1.0. For more information on applications of these elements, visit the [Schema Commentary document](/schema/schema-commentary.md).
## Brief

| Label 						| uri| Required?|
|-------------------						|-----------------------|:----------:|
| [Identifier](#identifier)					| `dc_identifier_s`| X|
| [Rights](#rights)							| `dc_rights_s`| X|
| [Title](#title)							| `dc_title_s`| X|
| [Provenance](#provenance)					| `dct_provenance_s`| X|
| [Schema Version](#schema-version)			| `geoblacklight_version`| X|
| [Slug](#slug)								| `layer_slug_s`| X|
| [Bounding Box](#bounding-box)				| `solr_geom`| X|
| [Solr Year](#solr-year)					| `solr_year_i`||
| [Creator](#creator)						| `dc_creator_sm`||
| [Description](#description)				| `dc_description_s`||
| [Format](#format)							| `dc_format_s`||
| [Language](#language)						| `dc_language_sm`||
| [Publisher](#publisher)					| `dc_publisher_sm`||
| [Source](#source)							| `dc_source_sm`||
| [Subject](#subject)						| `dc_subject_sm`||
| [Type](#type)								| `dc_type_s`||
| [Is Part Of](#is-part-of)					| `dct_isPartOf_sm`||
| [Date Issued](#date-issued)				| `dct_issued_s`||
| [References](#references)					| `dct_references_s`||
| [Spatial Coverage](#spatial-coverage)		| `dct_spatial_sm`||
| [Temporal Coverage](#temporal-coverage)	| `dct_temporal_sm`||
| [Geometry Type](#geometry-type)			| `layer_geom_type_s`||
| [Layer ID](#layer-id)						| `layer_id_s`||
| [Modified Date](#modified-date)			| `layer_modified_dt`|||


## Details

### Identifier
| Label							| Identifier|
|:------------------------------|:-----------|
| uri							| `dc_identifier_s`|
| Required						| yes|
| Type							| string|
| Description					| Unique identifier for layer as a URI. It should be globally unique across all institutions, assumed not to be end-user visible|
| Entry Guidelines				| This is usually in the form of http://institution/id.|
| Controlled Vocabulary			| no|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "http://purl.stanford.edu/vr593vj7147"|


### Rights
| Label							| Rights|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_rights_s`|
| Required						| yes|
| Type							| string|
| Description					| Signals access in the geoportal and is indicated by a padlock icon. Users need to sign in to download restricted items|
| Entry Guidelines				| Choose either Public or Restricted|
| Controlled Vocabulary			| "Public" or "Restricted"|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "Public"|

### Title
| Label							| Title|
|:------------------------------|:-----------|
| uri							| `dc_title_s`|
| Required						| yes|
| Type							| string|
| Description					| The name of the resource|
| Entry Guidelines				| Titles should include place names and dates when available.|
| Controlled Vocabulary			| no|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "Roads: Minneapolis, Minnesota, 2010"|

### Provenance
| Label							| Provenance|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_provenance_s`|
| Required						| yes|
| Type							| string|
| Description					| The name of the institution that holds the resource or acts as the custodian for the metadata record|
| Entry Guidelines				| The value for this field should be one of the agreed upon shortened names for each institution. This will embed the correct icon into the search results and item pages.|
| Controlled Vocabulary			| This repository contains the insitutions that have shared icons: https://github.com/geoblacklight/geoblacklight-icons|
| Element Set					| DCMI Metadata Terms|
| Example						| "Stanford"|

### Schema Version
| Label							| Schema Version|
|:------------------------------|:---------------------------------------------------------|
| uri							| `geoblacklight_version`	|
| Required						| yes|
| Type							| string|
| Description					| Indicates which version of the GeoBlacklight schema is in use|
| Entry Guidelines				| Only current value is "1.0"|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "1.0"|

### Slug
| Label							| Slug|
|:------------------------------|:---------------------------------------------------------|
| uri							| `layer_slug_s`|
| Required						| yes|
| Type							| string|
| Description					| This is a string appended to the base URL of a GeoBlacklight installation to create a unique landing page for each resource. It is visible to the user and serves the purpose of forming a persistent URL for each catalog item.|
| Entry Guidelines				| This string must be a globally unique value. The value should be alpha-numeric characters separated by dashes.|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "stanford-andhra-pradesh-village-boundaries"|

### Bounding Box
| Label 						| Bounding Box|
|:------------------------------|:---------------------------------------------------------|
| uri							| `solr_geom`|
| Required						| yes|
| Type							| string|
| Description					| The rectangular extents of the resource. Note that this field is indexed as a Solr spatial (RPT) field|
| Entry Guidelines				| Bounding box of the layer as a ENVELOPE WKT (from the CQL standard) using coordinates in (West, East, North, South) order. The pattern is: ENVELOPE(.*,.*,.*,.*)|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "ENVELOPE(76.76, 84.76, 19.91, 12.62)"|

### Solr Year
| Label 						| Solr Year|
|:------------------------------|:---------------------------------------------------------|
| uri							| `solr_year_i`|
| Required						| no|
| Type							| integer|
| Description					| A four digit integer representing a year of temporal coverage or date issued for the resource. This field is used to populate the Year facet and the optional [Blacklight Range Limit gem](https://github.com/projectblacklight/blacklight_range_limit)|
| Entry Guidelines				| This field must be an integer.|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "1982"|

### Creator
| Label							| Creator|
|:------------------------------|:---------------------------------------------------------|
| uri 							| `dc_creator_sm`|
| Required						| no|
| Type							| array|
| Description					| The person(s) or organization that created the resource|
| Entry Guidelines				| This may be an individual or an organization. If available, it should match with the Library of Congress Name Authority File.|
| Controlled Vocabulary			| The suggested controlled vocabulary is the [Library of Congress Name Authority File](http://id.loc.gov/authorities/names.html).|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "George Washington", "Thomas Jefferson"|

### Description
| Label| Description|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_description_s`|
| Required						| no|
| Type							| string|
| Description					| At minimum, this is a reiteration of the title in sentence format. Other relevant information, such as data creation methods, data sources, and special licenses, may also be included.|
| Entry Guidelines				| This is a plain text field.|
| Controlled Vocabulary			| no|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "This polygon shapefile represents boundaries of election districts in New York City. It was harvested from the NYC Open Data Portal."|

### Format
| Label							| Format|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_format_s`|
| Required						| no|
| Type							| string|
| Description					| This indicates the file format of the data. If a download link is included, this value shows up on the item page display in the download widget|
| Entry Guidelines				| Choose from set values (see Format list)|
| Controlled Vocabulary			| [Format Controlled Vocabulary](/schema/format-values.md)|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "Shapefile"|

### Language
| Label							| Language|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_language_sm`|
| Required						| no|
| Type							| array|
| Description					| Indicates the language of the data or map|
| Entry Guidelines				| Spell out language (in English) instead of using the ISO 639-1 code (e.g.,“French” instead of “fra”).|
| Controlled Vocabulary			| no|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "English"|

### Publisher
| Label							| Publisher|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_publisher_s`|
| Required						| no|
| Type							| array|
| Description					| The organization that made the original resource available|
| Entry Guidelines				| This should always be an organization.|
| Controlled Vocabulary			| The suggested controlled vocabulary is the [Library of Congress Name Authority File](http://id.loc.gov/authorities/names.html).|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "ML InfoMap (Firm)"|

### Source
| Label							| Source|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_source_sm`|
| Required						| no|
| Type							| array|
| Description					| This is used to indicate parent/child relationships between data layers and activates the Data Relations widget in GeoBlacklight|
| Entry Guidelines				| This is only added to the child records. Enter the layer_slug_s of the parent record(s) into this field.|
| Controlled Vocabulary			| no|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "stanford-vr593vj7147"|

### Subject
| Label							| Subject|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_subject_sm`|
| Required						| no|
| Type							| array|
| Description					| These are theme or topic keywords|
| Entry Guidelines				| These should be consistent and chosen from a controlled vocabulary. Use sentence style capitalization, where only the first word of a phrase is capitalized.|
| Controlled Vocabulary			| Recommended thesauri are [ISO Topic Categories](https://www2.usgs.gov/science/about/thesaurus-full.php?thcode=15) and Library of Congress Subject Headings.|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "Census", "Human settlements"|


### Type
| Label							| Type|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dc_type_s`|
| Required						| no|
| Type							| string|
| Description					| This is a general element to indicate the larger genre of the resource|
| Entry Guidelines				| Choose from Dublin Core Type values|
| Controlled Vocabulary			| [Type Controlled Vocabulary](/schema/type-values.md)|
| Element Set					| Dublin Core Metadata Element Set|
| Example						| "Dataset"|

### Is Part Of
| Label							| Is Part Of|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_isPartOf_sm`|
| Required						| no|
| Type							| array|
| Description					| Holding entity for the layer, such as the title of a collection|
| Entry Guidelines				| Plain text that is indexed in the Collections facet|
| Controlled Vocabulary			| no|
| Element Set					| [DCMI Metadata Terms](http://dublincore.org/documents/dcmi-terms/)|
| Example						| "Village Maps of India"|

### Date Issued
| Label							| Date Issued|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_issued_s`|
| Required						| no|
| Type							| string|
| Description					| This is the publication date for the resource|
| Entry Guidelines				| Use any date format, such as the XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ)|
| Controlled Vocabulary			| no|
| Element Set					| [DCMI Metadata Terms](http://dublincore.org/documents/dcmi-terms/)|
| Example						| "2015-01-01"|

### References
| Label							| References|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_references_s`|
| Required						| no|
| Type							| string|
| Description					| This element is a hash of key/value pairs for different types of external links. It integrates external services and references using the CatInterOp approach|
| Entry Guidelines				| See [External Services](https://github.com/geoblacklight/geoblacklight/wiki/Schema#external-services)|
| Controlled Vocabulary			| [References URIs](/schema/references.md)|
| Element Set					| DCMI Metadata Terms|
| Example						| "dct_references_s": "{\"http://schema.org/url\":\"http://purl.stanford.edu/bm662dm5913\",\"http://schema.org/downloadUrl\":\"http://stacks.stanford.edu/file/druid:bm662dm5913/data.zip\"}"|

### Spatial Coverage
| Label							| Spatial Coverage|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_spatial_sm`|
| Required						| no|
| Type							| array|
| Description					| This field is for place name keywords|
| Entry Guidelines				| Place name text strings should be specified out to the nation level. It is typical for the place name to represent the largest extent the data layer represents.|
| Controlled Vocabulary			| Recommended thesaurus is [GeoNames](https://www.geonames.org/)|
| Element Set					| DCMI Metadata Terms|
| Example						| "Philadelphia, Pennsylvania, United States"|

### Temporal Coverage
| Label							| Temporal Coverage|
|:------------------------------|:---------------------------------------------------------|
| uri							| `dct_temporal_sm`|
| Required						| no|
| Type							| array|
| Description					| This represents the "Ground Condition" of the resource, meaning the time period data was collected or is intended to represent. Displays on the item page in the Year value|
| Entry Guidelines				| This is a text string and can indicate uncertainty|
| Controlled Vocabulary			| no|
| Element Set					| DCMI Metadata Terms|
| Example						| "2007-2009"|

### Geometry Type
| Label							| Geometry Type|
|:------------------------------|:---------------------------------------------------------|
| uri							| `layer_geom_type_s`|
| Required						| no|
| Type							| string|
| Description					| This element shows up as Data type in GeoBlacklight, and each value has an associated icon|
| Entry Guidelines				| Choose from set values (see Controlled Vocabulary Lists)|
| Controlled Vocabulary			| [Geometry Type Controlled Vocabulary](/schema/geometry-type-values.md)|
| Element Set					| GeoBlacklight|
| Example						| "Polygon"|

### Layer ID
| Label							| Layer ID|
|:------------------------------|:---------------------------------------------------------|
| uri							| `layer_id_s`|
| Required						| no|
| Type							| string|
| Description					| Indicates the layer id for any WMS or WFS web services listed in the dct_references_s field|
| Entry Guidelines				| Only the layer name is added here. The base service endpoint URLs (e.g. "https://maps-public.geo.nyu.edu/geoserver/sdr/wms") are added to the `dct_references_s` field.|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "druid:vr593vj7147"|

### Modified Date
| Label							| Modified Date|
|:------------------------------|:---------------------------------------------------------|
| uri							| `layer_modified_dt`|
| Required						| no|
| Type							| date-time|
| Description					| Last modification date for the metadata record|
| Entry Guidelines				| Use the XML Schema dateTime format (YYYY-MM-DDThh:mm:ssZ)|
| Controlled Vocabulary			| no|
| Element Set					| GeoBlacklight|
| Example						| "2015-01-01T12:00:00Z"|
