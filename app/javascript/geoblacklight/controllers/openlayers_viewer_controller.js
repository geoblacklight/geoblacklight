import { Map } from "ol";
import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";
import GeoJSON from "ol/format/GeoJSON";
import { FullScreen, defaults as defaultControls } from "ol/control";
import { pmTilesLayer, cogLayer } from "geoblacklight/openlayers/layers";
import basemaps from "geoblacklight/openlayers/basemaps";
import { Controller } from "@hotwired/stimulus";
import { pmTilesInspection } from "geoblacklight/openlayers/inspection";

export default class OpenlayersViewerController extends Controller {
  static values = {
    url: String,
    protocol: String,
    basemap: String,
    mapGeom: String,
    options: Object,
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
    this.map = new Map({
      target: this.element,
      controls: defaultControls().extend([new FullScreen()]),
      layers: [this.basemap, this.overlay],
    });
    this.map.getView().fit(this.extent, this.map.getSize());
    this.addInspection()
  }

  addInspection() {
    if (this.protocolValue == "Pmtiles") return pmTilesInspection(this.map);
  }

  async getBounds() {
    if (this.protocolValue == 'Cog') {
      const view = await this.overlay.getSource().getView();
      this.extent = view.extent;
    } else {
      this.extent = new GeoJSON()
      .readFeatures(this.mapGeomValue)[0]
      .getGeometry()
      .getExtent();
    }
  }

  // Select the configured basemap to use
  getBasemap() {
    const basemap = this.basemapDefinition();
    const layer = new TileLayer({
      source: new XYZ({
        ...basemap,
        url: this.normalizeUrl(basemap.url),
        // The leaflet definitions spell this `attribution`; OpenLayers wants
        // `attributions`. Accept either so one setting serves both viewers.
        attributions: basemap.attributions || basemap.attribution,
      }),
    });
    return layer;
  }

  // The basemap to draw, with any BASEMAPS values from settings.yml merged over
  // the shipped definition. This lets an application change a basemap's URL --
  // to add a CARTO API key, for example -- without restating the rest of the
  // definition, and lets it define basemaps of its own. Falls back to positron
  // for a name that resolves to nothing rather than drawing no basemap.
  basemapDefinition() {
    const name = this.basemapValue || "positron";
    const definition = { ...basemaps[name], ...this.basemapOverrides()[name] };
    return definition.url ? definition : basemaps.positron;
  }

  basemapOverrides() {
    return this.optionsValue.BASEMAPS || {};
  }

  // Leaflet and OpenLayers spell tile URL templates differently, so accept the
  // leaflet form a configured basemap is most likely to be written in: {s}
  // becomes OpenLayers' subdomain range, and {retina} drops out.
  normalizeUrl(url) {
    return url.replace(/\{s\}/g, "{a-d}").replace(/\{retina\}/g, "");
  }

  // Generate a layer based on the protocol
  getPreviewOverlay(protocol, url) {
    if (protocol === "Pmtiles") return pmTilesLayer(url);
    if (protocol === "Cog") return cogLayer(url);
    console.error(`Unsupported protocol name: "${protocol}"`);
  }
}
