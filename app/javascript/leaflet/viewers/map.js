import { layerGroup, LatLngBounds, polygon, geoJSON, map } from "leaflet";
import basemaps from "../basemaps.js";
import { geoJSONToBounds } from "../utils.js";
import LeafletViewerBase from "./base.js";

export default class LeafletViewerMap extends LeafletViewerBase {
  constructor(element, options) {
    super(element);

    this.options = {
      // Initial bounds of map
      bbox: [
        [-82, -144],
        [77, 161],
      ],
      opacity: 0.75,
      ...options,
    };

    this.overlay = layerGroup();
    this.onLoad();
  }

  onLoad() {
    if (this.data.mapGeom) {
      this.options.bbox = geoJSONToBounds(JSON.parse(this.data.mapGeom));
    }

    this.map = map(this.element).fitBounds(this.options.bbox);

    // Add initial bbox to map element for easier testing
    if (this.map.getBounds().isValid()) {
      this.element.setAttribute(
        "data-js-map-render-bbox",
        this.map.getBounds().toBBoxString()
      );
    }

    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
  }

  addBoundsOverlay(bounds) {
    if (bounds instanceof LatLngBounds) {
      this.overlay.addLayer(
        polygon([
          bounds.getSouthWest(),
          bounds.getSouthEast(),
          bounds.getNorthEast(),
          bounds.getNorthWest(),
        ])
      );
    }
  }

  removeBoundsOverlay() {
    this.overlay.clearLayers();
  }

  addGeoJsonOverlay(geojson) {
    const layer = geoJSON();
    layer.addData(geojson);
    this.overlay.addLayer(layer);
  }

  selectBasemap() {
    return this.data.basemap ? basemaps[this.data.basemap] : basemaps.positron;
  }
}
