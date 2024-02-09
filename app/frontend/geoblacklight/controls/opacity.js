import GeoBlacklight from '../geoblacklight.js'

// Leaflet opacity control.
GeoBlacklight.Controls.Opacity = function() {
  this.map.addControl(new L.Control.LayerOpacity(this.overlay));
};
