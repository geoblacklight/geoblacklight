import LeafletViewerMap from "../viewers/map.js";
import LeafletViewerCog from "../viewers/cog.js";
import LeafletViewerEsri from "../viewers/esri.js";
import LeafletViewerEsriDynamicMapLayer from "../viewers/esri/dynamic_map_layer.js";
import LeafletViewerEsriFeatureLayer from "../viewers/esri/feature_layer.js";
import LeafletViewerEsriImageMapLayer from "../viewers/esri/image_map_layer.js";
import LeafletViewerEsriTiledMapLayer from "../viewers/esri/tiled_map_layer.js";
import LeafletViewerIiif from "../viewers/iiif.js";
import LeafletViewerIndexMap from "../viewers/index_map.js";
import LeafletViewerOembed from "../viewers/oembed.js";
import LeafletViewerPmtiles from "../viewers/pmtiles.js";
import LeafletViewerTileJson from "../viewers/tilejson.js";
import LeafletViewerTms from "../viewers/tms.js";
import LeafletViewerWms from "../viewers/wms.js";
import LeafletViewerWmts from "../viewers/wmts.js";
import LeafletViewerXyz from "../viewers/xyz.js";

const dict = new Map([
  ["Map", LeafletViewerMap],
  ["Cog", LeafletViewerCog],
  ["Esri", LeafletViewerEsri],
  ["DynamicMapLayer", LeafletViewerEsriDynamicMapLayer],
  ["FeatureLayer", LeafletViewerEsriFeatureLayer],
  ["ImageMapLayer", LeafletViewerEsriImageMapLayer],
  ["TiledMapLayer", LeafletViewerEsriTiledMapLayer],
  ["Iiif", LeafletViewerIiif],
  ["IndexMap", LeafletViewerIndexMap],
  ["Oembed", LeafletViewerOembed],
  ["Pmtiles", LeafletViewerPmtiles],
  ["Tilejson", LeafletViewerTileJson],
  ["Tms", LeafletViewerTms],
  ["Wms", LeafletViewerWms],
  ["Wmts", LeafletViewerWmts],
  ["Xyz", LeafletViewerXyz],
]);

// Leaflet map that displays on item show page
export default class ItemMap {
  constructor(element) {
    const viewerName = element.getAttribute("data-protocol");
    this.viewer = new (dict.get(viewerName))(element);
  }
}
