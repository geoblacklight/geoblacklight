//= require geoblacklight/viewers/wms

GeoBlacklight.Viewer.Xyz = GeoBlacklight.Viewer.Wms.extend({

  addPreviewLayer: function() {
    var _this = this;
    var xyzLayer = L.tileLayer(this.data.url);
    this.overlay.addLayer(xyzLayer);
  }
});
