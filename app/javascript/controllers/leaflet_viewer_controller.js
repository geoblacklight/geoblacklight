import { Icon, Control } from "leaflet";
import "leaflet-fullscreen";
import { layerGroup, polygon, map, tileLayer } from "leaflet";
import { imageMapLayer } from "esri-leaflet";
import { Controller } from "@hotwired/stimulus";
import basemaps from "../leaflet/basemaps.js";
import LayerOpacityControl from "../leaflet/controls/layer_opacity.js";
import GeoSearchControl from "../leaflet/controls/geosearch.js";
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

export default class LeafletViewerController extends Controller {
  static values = {
    url: String,
    catalogBaseUrl: String,
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
    if (!this.optionsValue.VIEWERS || !this.hasProtocolValue) return {};
    return this.optionsValue.VIEWERS[this.protocolValue.toUpperCase()];
  }

  // Create the map, add layers, and fit the bounds
  loadMap() {
    if (this.map) return;

    // Set up the map and fit to bounds
    this.map = map(this.element);
    this.map.addLayer(this.basemap);
    this.map.addLayer(this.overlay);
    this.map.fitBounds(this.bounds);

    // Add the layer preview, if available, and controls
    if (this.availableValue) this.addPreviewOverlay();
    this.addControls();

    // If we didn't add a preview, draw the bounds instead (if configured)
    // This is used when the data is unavailable to render
    if (!this.previewOverlay && this.drawInitialBoundsValue) {
      this.addBoundsOverlay(this.bounds);
    }

    // Enable geosearch if available
    if (this.map.geosearch) this.map.geosearch.enable();

    // Emit an event for other controllers to listen to
    this.dispatch("loaded");
  }

  // Set the bounds of the map to an L.LatLngBounds object
  // FIXME we have to turn off geosearch so that fitting the map doesn't
  // register as a search, but it still does anyway?
  fitBounds(bounds) {
    if (this.map.geosearch) this.map.geosearch.disable();
    this.map.fitBounds(bounds);
    this.bounds = bounds;
    if (this.map.geosearch) this.map.geosearch.enable();
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
    // Add any top-level controls (e.g. geosearch) first
    const globalControls = this.optionsValue.CONTROLS || {};
    Object.entries(globalControls).forEach(([controlName, controlOptions]) => {
      const control = this.getControl(controlName, controlOptions);
      if (control) this.addControl(control);
    });

    // If there are controls configured for this protocol type, and we
    // successfully added an available layer of that type, add its controls
    const protocolControls = this.config.CONTROLS || [];
    if (this.availableValue && this.previewOverlay) {
      protocolControls.forEach((controlName) => {
        const control = this.getControl(controlName);
        if (control) this.addControl(control);
      });
    }
  }

  // Add a pre-configured L.Control instance to the map
  addControl(control) {
    this.map.addControl(control);
  }

  // Look up the control name and return the corresponding L.Control instance
  getControl(controlName, controlOptions) {
    if (controlName == "Opacity")
      return new LayerOpacityControl(this.previewOverlay);
    if (controlName == "Fullscreen")
      return new Control.Fullscreen({ position: "topright", ...controlOptions });
    if (controlName == "Geosearch")
      return new GeoSearchControl({ baseUrl: this.catalogBaseUrlValue, ...controlOptions });
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
