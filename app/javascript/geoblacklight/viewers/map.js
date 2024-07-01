import GeoBlacklight from "@/geoblacklight/geoblacklight";
import GeoBlacklightViewer from "./viewer.js";

class GeoBlacklightViewerMap extends GeoBlacklightViewer {
  constructor(el, options) {
    super(el, options);

    this.options = {
      // Initial bounds of map
      bbox: [
        [-82, -144],
        [77, 161],
      ],
      opacity: 0.75,
      ...options,
    };

    this.overlay = L.layerGroup();

    // trigger viewer load function
    this.load();
  }

  load() {
    if (this.data.mapGeom) {
      this.options.bbox = L.geoJSONToBounds(JSON.parse(this.data.mapGeom));
    }

    this.map = L.map(this.element).fitBounds(this.options.bbox);

    // Add initial bbox to map element for easier testing
    if (this.map.getBounds().isValid()) {
      this.element.setAttribute(
        "data-js-map-render-bbox",
        this.map.getBounds().toBBoxString()
      );
    }

    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.map !== "index") {
      this.addBoundsOverlay(this.options.bbox);
    }
  }

  addBoundsOverlay(bounds) {
    if (bounds instanceof L.LatLngBounds) {
      this.overlay.addLayer(
        L.polygon([
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
    const layer = L.geoJSON();
    layer.addData(geojson);
    this.overlay.addLayer(layer);
  }

  selectBasemap() {
    return this.data.basemap
      ? GeoBlacklight.Basemaps[this.data.basemap]
      : GeoBlacklight.Basemaps.positron;
  }
}

export default GeoBlacklightViewerMap;
