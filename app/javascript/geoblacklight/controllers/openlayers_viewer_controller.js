import { Controller } from "@hotwired/stimulus";
import ol from "ol";
// import { FullScreen, defaults as defaultControls } from "ol/control";
// import GeoJSON from "ol/format/GeoJSON";
// import TileLayer from "ol/layer/Tile";
// import XYZ from "ol/source/XYZ";
import basemaps from "geoblacklight/openlayers/basemaps";
import { cogLayer, pmTilesLayer } from "geoblacklight/openlayers/layers";

export default class OpenlayersViewerController extends Controller {
  static values = {
    url: String,
    protocol: String,
    basemap: String,
    mapGeom: String,
  };

  async connect() {
    // Set up layers
    this.basemap = this.getBasemap();
    this.overlay = this.getPreviewOverlay(this.protocolValue, this.urlValue);

    await this.getBounds();
    // Load the map
    this.loadMap();
  }

  // Create the map, add layers, and fit the bounds
  loadMap() {
    this.map = new ol.Map({
      target: this.element,
      controls: ol.controls.defaults().extend([new ol.controls.FullScreen()]),
      layers: [this.basemap, this.overlay],
    });
    this.map.getView().fit(this.extent, this.map.getSize());
  }

  async getBounds() {
    if (this.protocolValue == 'Cog') {
      const view = await this.overlay.getSource().getView();
      this.extent = view.extent;
    } else {
      this.extent = new ol.format.GeoJSON()
      .readFeatures(this.mapGeomValue)[0]
      .getGeometry()
      .getExtent();
    }
  }

  // Select the configured basemap to use
  getBasemap() {
    const basemap = basemaps[this.basemapValue || "positron"];
    const layer = new ol.layer.TileLayer({ source: new ol.source.XYZ(basemap) });
    return layer;
  }

  // Generate a layer based on the protocol
  getPreviewOverlay(protocol, url) {
    if (protocol === "Pmtiles") return pmTilesLayer(url);
    if (protocol === "Cog") return cogLayer(url);
    console.error(`Unsupported protocol name: "${protocol}"`);
  }
}
