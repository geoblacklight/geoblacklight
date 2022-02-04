//= require geoblacklight/viewers/wms

GeoBlacklight.Viewer.Tilejson = GeoBlacklight.Viewer.Wms.extend({

  addPreviewLayer: function() {
    var _this = this;
    fetch(this.data.url).then(function(response) {
      if (!response.ok) {
          throw new Error("Unable to fetch tile.json document");
      }
      return response.json();
    }).then(function(tilejson) {
      var bounds = _this.getBounds(tilejson),
          options = bounds ? { bounds: bounds } : {},
          url = tilejson.tiles[0],
          tileJsonLayer = L.tileLayer(url, options);
      _this.overlay.addLayer(tileJsonLayer);
    }).catch(function(error) {
      console.debug(error);
    });
  },

  getBounds: function(doc) {
    // Get the bounds from the document, if they exist, and
    // convert to a Leaflet latlngBounds object
    var bounds = doc.bounds;
    if(bounds) {
      var corner1 = L.latLng(bounds[1], bounds[0]),
          corner2 = L.latLng(bounds[3], bounds[2]);
      return L.latLngBounds(corner1, corner2);
    }
  }
});
