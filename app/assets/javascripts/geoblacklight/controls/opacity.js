// Leaflet opacity control.
GeoBlacklight.Controls.Opacity = function(viewer) {
  viewer.map.addControl(new L.Control.LayerOpacity(viewer.overlay));
};
