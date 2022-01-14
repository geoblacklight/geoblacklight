//= require geoblacklight/viewers/wms

GeoBlacklight.Viewer.Tms = GeoBlacklight.Viewer.Wms.extend({

  addPreviewLayer: function() {
    var _this = this;
    var tmsLayer = L.tileLayer(this.data.url, { tms: true });
    this.overlay.addLayer(tmsLayer);
  }
});
