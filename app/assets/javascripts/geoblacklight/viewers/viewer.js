/*global GeoBlacklight */

// base viewer
GeoBlacklight.Viewer = L.Class.extend({
  options: {},

  initialize: function(el, options) {
    this.element = el;
    this.data = $(el).data();

    L.Util.setOptions(this, options);

    // trigger viewer load functions
    this.load();
  },

  /**
  * Loads leaflet controls from controls directory.
  **/
  loadControls: function() {
    var _this = this;
    var protocol = this.data.protocol.toUpperCase();
    var options = this.data.leafletOptions;

    if (!options.VIEWERS) {
      return;
    }

    var viewer = options.VIEWERS[protocol];
    var controls = viewer && viewer.CONTROLS;

    _this.controlPreload();

    /**
    * Loop though the GeoBlacklight.Controls hash, and for each control,
    * check to see if it is included in the controls list for the current
    * viewer. If it is, then pass in the viewer object and run the function
    * that adds it to the map.
    **/
    $.each(GeoBlacklight.Controls, function(name, func) {
      if (controls && controls.indexOf(name) > -1) {
        func.call(_this);
      }
    });
  },

  /**
  * Work to do before the controls are loaded.
  **/
  controlPreload: function() {
    return;
  },

  /**
  * Gets the value of detect retina from application settings.
  **/
  detectRetina: function() {
    var options = this.data.leafletOptions;
    if (options && options.LAYERS) {
      return options.LAYERS.DETECT_RETINA ? options.LAYERS.DETECT_RETINA : false;
    } else {
      return false;
    }
  }
});
