# Listing of GeoBlacklight .json test documents

If you add a new document, please add it to the table below, and indicate its purpose.

# Listing of GeoBlacklight .json test documents

If you add a new document, please add it to the table below, and indicate its purpose.

                       |
| Filename                | Title                 | ID        | Purpose           |
|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [actual-papermap1](actual-papermap1.json) | 1:1 500 000 series [cartographic material] : tectonic map of Britain, Ireland and adjacent areas / British Geological Survey ; Geological Survey of Ireland ; Geological Survey of Northern Ireland. | mit-001145244 | Nondigitized paper map with a link to a library catalog
| [actual-point1](actual-point1.json) | 2014 New York City Places | nyu-2451-34564 | Point dataset with WMS and WFS             
| [actual-polygon1](actual-polygon1.json) | 100 Foot Grid Cambridge MA 2004 | tufts-cambridgegrid100-04 | Polygon dataset (no direct download) with WFS, WMS, and FGDC metadata as XML    
| [actual-raster1](actual-raster1.json)| 1-Meter Shaded Relief Multibeam Bathymetry Image (Color): Elkhorn Slough, California, 2005 | stanford-dp018hs9766 | Restricted raster layer with WMS and metadata in MODS and ISO 19139
| [baruch_ancestor1](baruch_ancestor1.json) | 2016 NYC Geodatabase, Open Source Version (jan2016) | nyu_2451_34635 | SQLite Database with documentation download Referenced as parent     
| [baruch_ancestor2](baruch_ancestor2.json) | 2016 NYC Geodatabase, ArcGIS Version (jan2016) | nyu_2451_34636 | Geodatabase with documentation download Referenced as parent                   
| [baruch_documentation_download](baruch_documentation_download.json) | 2015 New York City Subway Complexes and Ridership | nyu_2451_34502 | Point dataset with WMS and WFS, documentation download, and two parent records
| [bbox-spans-180](bbox-spans-180.json) | East Asia and Oceania | princeton-sx61dn82p | Scanned map with IIIF and direct TIFF download that spans across the 180th meridian                     
| [cornell_html_metadata](cornell_html_metadata.json) | Air Monitoring Stations, Adirondack Park, 2000 | cugir-007741 | Point dataset with WMS, WFS, direct download, and FGDC metadata XML and HTML                       
| [esri-dynamic-layer-all-layers](esri-dynamic-layer-all-layers.json) | Glacial Boundaries: Illinois, 1998 | 90f14ff4-1359-4beb-b931-5cb41d20ab90 | This record points to an the top level of an Esri Rest Web Map Service It does not specify a layer
| [esri-dynamic-layer-single-layer](esri-dynamic-layer-single-layer.json) | Abandoned Quarries: Indiana | 4669301e-b4b2-4c8b-bf40-01b968a2865b | ArcGIS Dynamic Map Layer with single layer indicated
| [esri-feature-layer](esri-feature-layer.json) | Transit - Airports: Maryland | f406332e63eb4478a9560ad86ae90327_18| ArcGIS Feature Layer - point dataset |
| [esri-image-map-layer](esri-image-map-layer.json)| Wabash Topo (27): Indiana, 1929 | 32653ed6-8d83-4692-8a06-bf13ffe2c018 | ArcGIS Image Map Layer with GeoTIFF direct download
| [esri-tiled_map_layer](esri-tiled_map_layer.json)| Soil Survey Geographic (SSURGO) | nyu-test-soil-survey-map | ArcGIS tiled map layer
| [esri-wms-layer](esri-wms-layer.json) | Agriculture Census: Indiana, 1997 | purdue-urn-f082acb1-b01e-4a08-9126-fd62a23fd9aa | Dataset with ArcGIS Dynamic Map Layer, ArcGIS WMS, and direct download                       
| [harvard_raster](harvard_raster.json) | Saint Petersburg Region, Russia, 1834 (Raster Image) | harvard-g7064-s2-1834-k3 | This layer is a georeferenced raster image of the historic paper map
| [iiif-eastern-hemisphere](iiif-eastern-hemisphere.json) | A new & accurate map of Asia: drawn from actual surveys, and otherwise collected from journals | 57f0f116-b64e-4773-8684-96ba09afb549                        | Eastern hemisphere scanned map with IIIF manifest
| [index_map_point](index_map_point.json) | New York Aerial Photos (1960s) | cornell-ny-aerial-photos-1960s | GeoJSON index map of points
| [index-map-polygon](index-map-polygon.json) | Index of Digital Elevation Models (DEM), New York | cugir-008186-no-downloadurl | GeoJSON index map of polygons, with a downloadUrl for the index itself               
| [index-map-polygon-no-downloadurl](index-map-polygon-no-downloadurl.json) | Index of Digital Elevation Models (DEM), New York | cugir-008186 | GeoJSON index map of polygons, but lacking a downloadUrl for the index itself
| [index-map-stanford](index-map-stanford.json) | Dabao Kinbōzu, Maps Index | stanford-fb897vt9938 | old-style (pre-GeoJSON) index map of rectangular polygons
| [metadata_no_geom](metadata_no_geom.json) | Ames Library of South Asia Maps | 05d-p16022coll246-noGeo | This is a collection level record without spatial coordinates
| [metadata_no_provider](metadata_no_provider.json)| Social Explorer | 99-0001-noprovider | This is a website record that does not have a Provider (aardvark)/ provider (GBL Metadata 1.0)
| [multiple-downloads](multiple-downloads.json) | Test record with additional download formats | cugir-007950 | This is a test record containing new-style references as nested child documents In addition to the original shapefile download, the references section contains additional PDF and KMZ downloads
| [no_locn_geometry](no_locn_geometry.json) | University of Minnesota Digital Conservancy DRUM | 05d-03-noGeomType | This is a collection level record without spatial coordinates or a Geometry Type (GBL Metadata 1.0)
| [no_spatial](no_spatial.json) | ASTER Global Emissivity Dataset 1-kilometer V003 - AG1KM                | aster-global-emissivity-dataset-1-kilometer-v003-ag1kmcad20 | File without geometry type or locn_geometry (will cause error)      |
| [oembed](oembed.json) | Jōshū Kusatsu Onsenzu | stanford-dc482zx1528 | This record has an Oembed reference link
| [princeton-child1](princeton-child1.json) | Princeton, Mercer County, New Jersey (Sheet 1) | princeton-n009w382v | Child record for testing the gbl_suppressed_b property
| [princeton-child2](princeton-child2.json) | Princeton, Mercer County, New Jersey (Sheet 2) | princeton-jq085m62x | Child record for testing the gbl_suppressed_b property
| [princeton-child3](princeton-child3.json) | Princeton, Mercer County, New Jersey (Sheet 3) | princeton-n009w382v-fake1 | Child record for testing the gbl_suppressed_b property
| [princeton-child4](princeton-child4.json) | Princeton, Mercer County, New Jersey (Sheet 4) | princeton-n009w382v-fake2 | Child record for testing the gbl_suppressed_b property
| [princeton-parent](princeton-parent.json) | Princeton, Mercer County, New Jersey | princeton-1r66j405w | Parent record for testing the gbl_suppressed_b property
| [public_direct_download](public_direct_download.json) | 2005 Rural Poverty GIS Database: Uganda | stanford-cz128vq0535 | includes a tentative dcat_distribution_sm property
| [public_iiif_princeton](public_iiif_princeton.json) | The provinces of New York and New Jersey, with part of Pensilvania, and the Province of Quebec | princeton-02870w62c | Scanned map with IIIF       
| [public_polygon_mit](public_polygon_mit.json) | Massachusetts (ZCTA - 5 digit zip code tabulation area, 2000) | mit-f6rqs4ucovjk2 | Polygon shapefile with WMS and WFS
| [restricted-line](restricted-line.json) | 10 Meter Contours: Russian River Basin, California | stanford-cg357zz0321 | Restricted line layer with WFS, WMS and metadata in MODS and ISO 19139  
| [tms](tms.json) | Agricultural Districts, Columbia County NY, 2009 (TMS) | cugir-007957 | Includes a reference to a TMS web service
| [umn_metro_result1](umn_metro_result1.json) | 2030 Regional Development Framework Planning Areas: Metro Twin Cities, Minnesota, 2011| 02236876-9c21-42f6-9870-d2562da8e44f | Bounding box of metropolitan area and ArcGIS Dynamic Feature Service
| [umn_state_result1](umn_state_result1.json) | 1:100k Digital Raster Graphic - Collars Removed: Minnesota | 2eddde2f-c222-41ca-bd07-2fd74a21f4de | Bounding box of state area and static image in references           
| [umn_state_result2](umn_state_result2.json) | 1:250k Digital Raster Graphic - Collars Removed: Minnesota | e9c71086-6b25-4950-8e1c-84c2794e3382 | Bounding box of state area and raster download    
| [uva_slug_colon](uva_slug_colon.json) | Norfolk 2005 Police Stations | uva-Norfolk:police_point | Multipoint dataset with WMS and WFS and a colon in the slug and layer ID
| [wmts-multiple](wmts-multiple.json) | Orthofoto 2016 Wien (WMTS) | princeton-fk4db9hn29 | Raster dataset with gbl_wxsIdentifier_s value and reference to WMTS service that supports multiple layers
| [wmts-single-layer](wmts-single-layer.json) | The Balkans [and] Turkey : G.S.G.S. no. 2097 | princeton-fk4544658v-wmts | Raster mosaic dataset with reference to a WMTS service that supports one layer
| [xyz](xyz.json)| Quaternary Fault and Fold Database of the United States (XYZ) | 6f47b103-9955-4bbe-a364-387039623106-xyz | Line shapefile with an XYZ tile service reference
