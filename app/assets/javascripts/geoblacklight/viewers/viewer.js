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
    var viewer = options.VIEWERS[protocol];
    var controls = viewer && viewer.CONTROLS;

    this.controlPreload();

    /**
    * Loop though the GeoBlacklight.Controls hash, and for each control,
    * check to see if it is included in the controls list for the current
    * viewer. If it is, then pass in the viewer object and run the function
    * that adds it to the map.
    **/
    $.each(GeoBlacklight.Controls, function(name, func) {
      if (controls.indexOf(name) > -1) {
        func(_this);
      }
    });
  },

  /**
  * Work to do before the controls are loaded.
  **/
  controlPreload: function() {
    return;
  }
});
