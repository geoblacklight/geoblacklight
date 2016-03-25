// Leaflet fullscreen control.
GeoBlacklight.Controls.Fullscreen = function(viewer) {
  viewer.map.addControl(new L.Control.Fullscreen({
    pseudoFullscreen: true
  }));
};
