/*global GeoBlacklight */

// Leaflet fullscreen control.
GeoBlacklight.Controls.Fullscreen = function() {
  this.map.addControl(new L.Control.Fullscreen({
    position: 'topright'
  }));
};
