import GeoBlacklightLeafletPlugin from '../leaflet_plugin.js'

// Leaflet fullscreen control.
GeoBlacklightLeafletPlugin.Controls.Fullscreen = function() {
  this.map.addControl(new L.Control.Fullscreen({
    position: 'topright'
  }));
};
