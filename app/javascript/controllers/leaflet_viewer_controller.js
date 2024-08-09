import { Icon, Control } from "leaflet";
import "leaflet-fullscreen";
import { layerGroup, polygon, map, tileLayer } from "leaflet";
import { imageMapLayer } from "esri-leaflet";
import { Controller } from "@hotwired/stimulus";
import basemaps from "../leaflet/basemaps.js";
import LayerOpacityControl from "../leaflet/controls/layer_opacity.js";
import GeoSearchControl from "../leaflet/controls/geosearch.js";
import { wmsInspection,
  tiledMapLayerInspection,
  featureLayerInspection,
  dynamicMapLayerInspection
} from "../leaflet/inspection.js";
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
import { DEFAULT_BOUNDS, DEFAULT_OPACITY } from "../leaflet/constants.js";

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
    // TODO: figure out why vite @leaftlet_images alias is not working.
    Icon.Default.imagePath = "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/";

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

  // Create the map, add layers, fit the bounds
  async loadMap() {
    if (this.map) return;

    // Set up the map and fit to bounds
    this.map = map(this.element);
    this.map.addLayer(this.basemap);
    this.map.addLayer(this.overlay);
    this.fitBounds(this.bounds);
    this.map.options.selected_color = this.optionsValue.SELECTED_COLOR || 'blue';

    // If the data is available, add the preview and set up inspection
    // Otherwise just draw the bounds, if configured to do so
    if (this.availableValue && this.protocolValue) {
      await this.addPreviewOverlay();
      this.addInspection();
    } else if (this.drawInitialBoundsValue && this.bounds) {
      if (this.mapGeomValue) this.map.addLayer(L.geoJSON(this.mapGeomValue))
      this.addBoundsOverlay(this.bounds);
    }

    // Add configured controls
    this.addControls();

    if (this.protocolValue == "IndexMap"){
      this.fitBounds(this.previewOverlay.getBounds())
    }

    // Enable geosearch handler, if available
    if (this.map.geosearch) this.map.geosearch.enable();

    // Emit an event for other controllers to listen to
    this.dispatch("loaded");
  }

  // Set the bounds of the map to an L.LatLngBounds object
  fitBounds(bounds) {
    // prevent map from moving when setting bounds, if relevant
    if (this.map.geosearch) this.map.geosearch.disable();
    this.map.fitBounds(bounds, { animate: false, noMoveStart: true });
    this.bounds = bounds;
    if (this.map.geosearch) this.map.geosearch.enable();
    this.element.dataset.bounds = this.bounds.toBBoxString();
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

    // Add opacity and fullscreen controls for all layers
    if (this.hasProtocolValue) {
      if (this.availableValue){
        const opacityControl = this.getControl("Opacity");
        this.addControl(opacityControl);
      }
      const fullscreenControl = this.getControl("Fullscreen");
      this.addControl(fullscreenControl);
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
    ],
      {
        color: '#3388ff',
        dashArray: "5 5",
        weight: 2,
        opacity: 1,
        fillOpacity: 0
      }
    );
    
    this.boundsOverlay = boundsOverlay;
    this.overlay.addLayer(boundsOverlay);
  }

  // Remove the bounding box overlay
  removeBoundsOverlay() {
    if (this.boundsOverlay) this.overlay.removeLayer(this.boundsOverlay);
  }

  addInspection() {
    if (this.protocolValue == "Wms") return wmsInspection(this.map, this.urlValue, this.layerIdValue, this.previewOverlay);
    if (this.protocolValue == "FeatureLayer") return featureLayerInspection(this.map, this.previewOverlay);
    if (this.protocolValue  == "DynamicMapLayer") return dynamicMapLayerInspection(this.map, this.previewOverlay, this.layerIdValue)
    // TODO: TiledMapLayer is converted but seems busted -- see layers.js. Don't know what to test it with, need a fixture.
    // if (this.protocolValue == "TiledMapLayer") return tiledMapLayerInspection(this.map, this.previewOverlay);
  }

  // Add the actual data to the map as a layer
  async addPreviewOverlay() {
    this.previewOverlay = await this.getPreviewOverlay(
      this.protocolValue,
      this.urlValue,
      {
        layerId: this.layerIdValue,
        opacity: this.optionsValue.opacity || DEFAULT_OPACITY,
        detectRetina: this.optionsValue.LAYERS.DETECT_RETINA || false,
      }
    );
    if (this.previewOverlay) this.overlay.addLayer(this.previewOverlay);
  }

  // Generate a layer based on the protocol
  async getPreviewOverlay(protocol, url, options) {
    if (protocol == "DynamicMapLayer") return esriDynamicMapLayer(url, options);
    if (protocol == "FeatureLayer") return esriFeatureLayer(url, options);
    // imageMapLayer is a built-in method from esri-leaflet
    if (protocol == "ImageMapLayer") return imageMapLayer({url, ...options});
    if (protocol == "IndexMap") return await indexMapLayer(url, this.optionsValue);
    if (protocol == "TiledMapLayer") return await esriTiledMapLayer(url, options);
    if (protocol == "Tilejson") return await tileJsonLayer(url, options);
    // tileLayer is a built-in method from leaflet
    if (protocol == "Tms") return tileLayer(url, { tms: true, ...options });
    if (protocol == "Wms") return wmsLayer(url, options);
    if (protocol == "Wmts") return await wmtsLayer(url, options);
    if (protocol == "Xyz") return tileLayer(url, options);
    console.error(`Unsupported protocol name: "${protocol}"`);
  }
}
