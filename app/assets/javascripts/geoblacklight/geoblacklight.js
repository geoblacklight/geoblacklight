//= require leaflet
//= require native.history
//= require_tree ./templates

!function(global) {
  'use strict';

  /**
   * Convert bounding box string to Leaflet LatLngBounds.
   * @param {String} bbox Space-separated string of sw-lng sw-lat ne-lng ne-lat
   * @return {L.LatLngBounds} Converted Leaflet LatLngBounds object
   */
  L.bboxToBounds = function(bbox) {
    bbox = bbox.split(' ');
    if (bbox.length === 4) {
      return L.latLngBounds([[bbox[1], bbox[0]], [bbox[3], bbox[2]]]);
    } else {
      throw "Invalid bounding box string";
    }
  };

  var GeoBlacklight = L.Class.extend({
    statics: {
      __version__: '2.0.0',

      debounce: function(fn, delay) {
        var timeout = null;
        return function() {
          var args = arguments, _this = this;
          clearTimeout(timeout);
          timeout = setTimeout(function() {
            fn.apply(_this, args);
          }, delay);
        };
      }
    }
  });

  // Hash for leaflet controls.
  GeoBlacklight.Controls = {};
  global.GeoBlacklight = GeoBlacklight;
}(this);
