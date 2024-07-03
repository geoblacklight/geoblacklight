import { Icon, Control } from "leaflet";
import "leaflet-fullscreen";
import LayerOpacityControl from "../controls/layer_opacity";

export default class LeafletViewerBase {
  constructor(element) {
    this.element = element;
    this.data = element.dataset;

    // Sets leaflet icon paths to ex. /assets/marker-icon-2x-rails-fingerprint
    Icon.Default.imagePath = "..";
  }

  // Look up the controls needed for this viewer type and add them to the map
  addControls() {
    // Get the protocol key (IIIF, WMS, etc.) and configured options
    const protocol = this.data.protocol.toUpperCase();
    const options = JSON.parse(this.data.leafletOptions || "{}");
    if (!options.VIEWERS) return;

    // Look up the configured controls for this protocol, if any
    const viewer = options.VIEWERS[protocol];
    const controls = viewer && viewer.CONTROLS;
    if (!controls) return;

    // Add each of the configured controls to the map
    controls.forEach((control) => {
      if (control === "Opacity") {
        this.map.addControl(new LayerOpacityControl(this.overlay));
      }
      if (control === "Fullscreen") {
        this.map.addControl(new Control.Fullscreen({ position: "topright" }));
      }
    });

    // Call the hook once controls are set up
    this.onAddControls(controls);
  }

  // Hook for any extra work to do after controls are added; override in subclass
  onAddControls(_controls) {}

  /**
   * Gets the value of detect retina from application settings.
   */
  detectRetina() {
    const options = JSON.parse(this.data.leafletOptions || "{}");
    return options && options.LAYERS ? options.LAYERS.DETECT_RETINA : false;
  }
}
