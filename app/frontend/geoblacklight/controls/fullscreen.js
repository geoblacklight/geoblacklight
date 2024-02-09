import GeoBlacklight from '../geoblacklight.js'

// Leaflet fullscreen control.
GeoBlacklight.Controls.Fullscreen = function() {
  this.map.addControl(new L.Control.Fullscreen({
    position: 'topright'
  }));
};
