class GeoBlacklightViewer extends L.Class {
  options = {};

  constructor(el, options) {
    super();
    this.element = el;
    // Access data attributes using dataset for vanilla JS
    this.data = el.dataset;

    L.Util.setOptions(this, options);

    // Sets leaflet icon paths to ex. /assets/marker-icon-2x-rails-fingerprint
    L.Icon.Default.imagePath = "..";
  }

  /**
   * Loads leaflet controls.
   */
  loadControls() {
    const protocol = this.data.protocol.toUpperCase();
    const options = JSON.parse(this.data.leafletOptions || "{}");

    if (!options.VIEWERS) return;
    const viewer = options.VIEWERS[protocol];
    const controls = viewer && viewer.CONTROLS;

    this.controlPreload();

    if (!controls) return;
    controls.forEach((control) => {
      if (control === "Opacity") {
        this.map.addControl(new L.Control.LayerOpacity(this.overlay));
      }
      if (control === "Fullscreen") {
        this.map.addControl(
          new L.Control.Fullscreen({ position: "topright" })
        );
      }
    });
  }

  /**
   * Work to do before the controls are loaded.
   */
  controlPreload() {
    // Define any preload actions here
  }

  /**
   * Gets the value of detect retina from application settings.
   */
  detectRetina() {
    // Assuming this.data.leafletOptions is a JSON string, parse it
    const options = JSON.parse(this.data.leafletOptions || "{}");
    return options && options.LAYERS ? options.LAYERS.DETECT_RETINA : false;
  }
}
// Export the GeoBlacklightViewer class
export default GeoBlacklightViewer;
