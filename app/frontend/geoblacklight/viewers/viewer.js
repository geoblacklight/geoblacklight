import GeoBlacklight from '../geoblacklight.js'
import '../controls/fullscreen.js'
import '../controls/opacity.js'

class GeoBlacklightViewer extends L.Class {
  options = {};

  constructor(el, options) {
    super();
    this.element = el;
    // Access data attributes using dataset for vanilla JS
    this.data = el.dataset;

    L.Util.setOptions(this, options);

    // Sets leaflet icon paths to ex. /assets/marker-icon-2x-rails-fingerprint
    L.Icon.Default.imagePath = '..';
  }

  /**
   * Loads leaflet controls from controls directory.
   */
  loadControls() {
    // Access protocol directly from this.data, converting to uppercase
    const protocol = this.data.protocol.toUpperCase();
    // Assuming this.data.leafletOptions is a JSON string, parse it
    const options = JSON.parse(this.data.leafletOptions || '{}');

    if (!options.VIEWERS) {
      return;
    }

    const viewer = options.VIEWERS[protocol];
    const controls = viewer && viewer.CONTROLS;

    this.controlPreload();

    /**
     * Loop through the GeoBlacklight.Controls hash, and for each control,
     * check to see if it is included in the controls list for the current
     * viewer. If it is, then pass in the viewer object and run the function
     * that adds it to the map.
     */
    // Replace $.each with Object.entries and forEach for vanilla JS iteration
    Object.entries(GeoBlacklight.Controls).forEach(([name, func]) => {
      if (controls && controls.indexOf(name) > -1) {
        func.call(this);
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
    const options = JSON.parse(this.data.leafletOptions || '{}');
    return options && options.LAYERS ? options.LAYERS.DETECT_RETINA : false;
  }
}
// Export the GeoBlacklightViewer class
export default GeoBlacklightViewer;
