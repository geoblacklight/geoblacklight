import { Icon, Control } from "leaflet";
import "leaflet-fullscreen";
import { layerGroup, polygon, map, tileLayer } from "leaflet";
import { imageMapLayer } from "esri-leaflet";
import { Controller } from "@hotwired/stimulus";
import basemaps from "../leaflet/basemaps.js";
import LayerOpacityControl from "../leaflet/controls/layer_opacity.js";
import {
  esriDynamicMapLayer,
  esriFeatureLayer,
  esriTiledMapLayer,
  tileJsonLayer,
  wmsLayer,
  wmtsLayer,
  indexMapLayer,
} from "../leaflet/layers.js";
import { geoJSONToBounds } from "../leaflet/utils.js";
import { DEFAULT_BOUNDS } from "../leaflet/constants.js";

// base
// ├── map
// │   ├── esri
// │   │   ├── dynamic map
// │   │   ├── feature layer
// │   │   ├── image map
// │   │   ├── tiled map
// │   ├── index map
// │   ├── wms
// │   │   ├── wmts
// │   │   ├── xyz
// │   │   ├── tms
// │   │   ├── tilejson

export default class LeafletViewerController extends Controller {
  static values = {
    url: String,
    protocol: String,
    available: Boolean,
    options: Object,
    basemap: String,
    mapGeom: Object,
    layerId: String,
    drawInitialBounds: Boolean,
  };

  connect() {
    // Sets leaflet icon paths to ex. /assets/marker-icon-2x-rails-fingerprint
    Icon.Default.imagePath = "..";

    // Set up layers
    this.basemap = this.getBasemap();
    this.overlay = layerGroup();

    // Calculate bounds
    this.bounds = DEFAULT_BOUNDS;
    if (this.hasMapGeomValue) this.bounds = geoJSONToBounds(this.mapGeomValue);

    // Load the map
    this.loadMap();
  }

  get config() {
    if (!this.optionsValue.VIEWERS) return {};
    return this.optionsValue.VIEWERS[this.protocolValue.toUpperCase()];
  }

  // Create the map, add layers, and fit the bounds
  loadMap() {
    if (this.map) return;

    this.map = map(this.element);
    this.map.addLayer(this.basemap);
    this.map.addLayer(this.overlay);
    this.fitBounds(this.bounds);

    // If the data is available, add the preview and controls
    // Otherwise just draw the bounds, if configured to do so
    if (this.availableValue) {
      this.addPreviewOverlay();
      if (this.previewOverlay) this.addControls();
    } else if (this.drawInitialBoundsValue && this.bounds) {
      this.addBoundsOverlay(this.bounds);
    }

    // Emit an event for other controllers to listen to
    this.dispatch("loaded");
  }

  // Set the bounds of the map to an L.LatLngBounds object
  fitBounds(bounds) {
    this.map.fitBounds(bounds);
    this.bounds = bounds;
  }

  // Select the configured basemap to use
  getBasemap() {
    const basemapName = this.basemapValue || "positron";
    return tileLayer(basemaps[basemapName].url, {
      ...basemaps[basemapName],
      detectRetina: this.optionsValue.LAYERS.DETECT_RETINA || false,
    });
  }

  // Add the configured controls to the map
  addControls() {
    const controlNames = this.config.CONTROLS || [];
    controlNames.forEach((controlName) => {
      const control = this.getControl(controlName);
      if (control) this.addControl(control);
    });
  }

  // Add a pre-configured L.Control instance to the map
  addControl(control) {
    this.map.addControl(control);
  }

  // Look up the control name and return the corresponding L.Control instance
  getControl(controlName) {
    if (controlName == "Opacity")
      return new LayerOpacityControl(this.previewOverlay);
    if (controlName == "Fullscreen")
      new Control.Fullscreen({ position: "topright" });
    console.error(`Unsupported control name: "${controlName}"`);
  }

  // Add the bounding box to the map
  addBoundsOverlay(bounds) {
    const boundsOverlay = polygon([
      bounds.getSouthWest(),
      bounds.getSouthEast(),
      bounds.getNorthEast(),
      bounds.getNorthWest(),
    ]);
    this.boundsOverlay = boundsOverlay;
    this.overlay.addLayer(boundsOverlay);
  }

  // Remove the bounding box overlay
  removeBoundsOverlay() {
    if (this.boundsOverlay) this.overlay.removeLayer(this.boundsOverlay);
  }

  // Add the actual data to the map as a layer
  async addPreviewOverlay() {
    this.previewOverlay = await this.getPreviewOverlay(
      this.protocolValue,
      this.urlValue,
      {
        layerId: this.layerIdValue,
        opacity: this.optionsValue.opacity,
        detectRetina: this.optionsValue.LAYERS.DETECT_RETINA || false,
      }
    );
    if (this.previewOverlay) this.overlay.addLayer(this.previewOverlay);
  }

  // Generate a layer based on the protocol
  async getPreviewOverlay(protocol, url, options) {
    if (protocol == "DynamicMapLayer") return esriDynamicMapLayer(url, options);
    if (protocol == "FeatureLayer") return esriFeatureLayer(url, options);
    if (protocol == "ImageMapLayer") return imageMapLayer({ url });
    if (protocol == "TiledMapLayer") return await esriTiledMapLayer(url);
    if (protocol == "IndexMap")
      return await indexMapLayer(url, this.optionsValue);
    if (protocol == "Wms") return wmsLayer(url, options);
    if (protocol == "Wmts") return await wmtsLayer(url, options);
    if (protocol == "Xyz") return tileLayer(url, options);
    if (protocol == "Tms") return tileLayer(url, { tms: true, ...options });
    if (protocol == "Tilejson") return await tileJsonLayer(url);
    console.error(`Unsupported protocol name: "${protocol}"`);
  }
}
