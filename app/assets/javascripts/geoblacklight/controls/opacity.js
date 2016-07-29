/*global GeoBlacklight */

// Leaflet opacity control.
GeoBlacklight.Controls.Opacity = function() {
  this.map.addControl(new L.Control.LayerOpacity(this.overlay));
};
