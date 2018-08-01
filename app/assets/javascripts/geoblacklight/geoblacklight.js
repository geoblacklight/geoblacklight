//= require leaflet
//= require native.history
//= require_tree ./templates

!function(global) {
  'use strict';

  /**
   * Convert bounding box string to Leaflet LatLngBounds.
   * @param {String} bbox Space-separated string of sw-lng sw-lat ne-lng ne-lat
   * @return {L.LatLngBounds} Converted Leaflet LatLngBounds object
   * bbox2_east_h = bbox[2] < 180 && bbox[2] > 50 close to the area of Russia. It is more likely
   * the bbox to cross the antimeridian when bbox[0] in bbox0_west_h.
   */
  L.bboxToBounds = function(bbox) {
    bbox = bbox.split(' ');
    let corner1, corner2, bbox0_west_h, bbox2_east_h, bbox0_east_h, bbox2_west_h;
    if (bbox.length === 4) {
      bbox0_west_h = bbox[0] > -180 && bbox[0] < 0
      bbox2_east_h = bbox[2] < 180 && bbox[2] > 50
      bbox0_east_h = bbox[0] > 0 && bbox[0] < 180
      bbox2_west_h = bbox[2] > -180 && bbox[2] < 0
      if ( ( bbox0_west_h ) && ( bbox2_east_h) ) {
        corner1 = L.latLng(bbox[1], parseFloat(bbox[0]) + 360, true);
        corner2 = L.latLng(bbox[3], bbox[2]);
      } else if ( (bbox0_east_h) && (bbox2_west_h) ) {
        corner1 = L.latLng(bbox[1], bbox[0]);
        corner2 = L.latLng(bbox[3], parseFloat(bbox[2]) + 360, true);
      } else {
        corner1 = L.latLng(bbox[1], bbox[0]);
        corner2 = L.latLng(bbox[3], bbox[2]);
      }
      return L.latLngBounds(corner1, corner2);
    } else {
      throw "Invalid bounding box string";
    }
  };

  var GeoBlacklight = L.Class.extend({
    statics: {
      __version__: '1.9.0',

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
