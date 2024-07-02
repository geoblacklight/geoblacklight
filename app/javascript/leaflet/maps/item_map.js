import GeoBlacklightViewerMap from "../viewers/map";
import GeoBlacklightViewerCog from "../viewers/cog";
import GeoBlacklightViewerEsri from "../viewers/esri";
import GeoBlacklightViewerEsriDynamicMapLayer from "../viewers/esri/dynamic_map_layer";
import GeoBlacklightViewerEsriFeatureLayer from "../viewers/esri/feature_layer";
import GeoBlacklightViewerEsriImageMapLayer from "../viewers/esri/image_map_layer";
import GeoBlacklightViewerEsriTiledMapLayer from "../viewers/esri/tiled_map_layer";
import GeoBlacklightViewerIiif from "../viewers/iiif";
import GeoBlacklightViewerIndexMap from "../viewers/index_map";
import GeoBlacklightViewerOembed from "../viewers/oembed";
import GeoBlacklightViewerPmtiles from "../viewers/pmtiles";
import GeoBlacklightViewerTileJson from "../viewers/tilejson";
import GeoBlacklightViewerTms from "../viewers/tms";
import GeoBlacklightViewerWms from "../viewers/wms";
import GeoBlacklightViewerWmts from "../viewers/wmts";
import GeoBlacklightViewerXyz from "../viewers/xyz";

const dict = new Map([
  ["Map", GeoBlacklightViewerMap],
  ["Cog", GeoBlacklightViewerCog],
  ["Esri", GeoBlacklightViewerEsri],
  ["DynamicMapLayer", GeoBlacklightViewerEsriDynamicMapLayer],
  ["FeatureLayer", GeoBlacklightViewerEsriFeatureLayer],
  ["ImageMapLayer", GeoBlacklightViewerEsriImageMapLayer],
  ["TiledMapLayer", GeoBlacklightViewerEsriTiledMapLayer],
  ["Iiif", GeoBlacklightViewerIiif],
  ["IndexMap", GeoBlacklightViewerIndexMap],
  ["Oembed", GeoBlacklightViewerOembed],
  ["Pmtiles", GeoBlacklightViewerPmtiles],
  ["Tilejson", GeoBlacklightViewerTileJson],
  ["Tms", GeoBlacklightViewerTms],
  ["Wms", GeoBlacklightViewerWms],
  ["Wmts", GeoBlacklightViewerWmts],
  ["Xyz", GeoBlacklightViewerXyz],
]);

// Leaflet map that displays on item show page
export default class ItemMap {
  constructor(element) {
    const viewerName = element.getAttribute("data-protocol");
    const viewer = new (dict.get(viewerName))(element);
    viewer.load();
  }
}
