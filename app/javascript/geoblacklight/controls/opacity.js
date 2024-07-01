import GeoBlacklightLeafletPlugin from '../leaflet_plugin.js'

// Leaflet opacity control.
GeoBlacklightLeafletPlugin.Controls.Opacity = function() {
  this.map.addControl(new L.Control.LayerOpacity(this.overlay));
};
