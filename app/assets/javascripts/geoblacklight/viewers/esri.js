//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Esri = GeoBlacklight.Viewer.Map.extend({
  layerInfo: {},

  load: function() {
    this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.available) {
      this.getEsriLayer();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  getEsriLayer: function() {
    var _this = this;

    // remove any trailing slash from endpoint url
    _this.data.url = _this.data.url.replace(/\/$/, '');

    L.esri.get = L.esri.Request.get.JSONP;
    L.esri.get(_this.data.url, {}, function(error, response){
      if(!error) {
        _this.layerInfo = response;

        // get layer as defined in submodules (e.g. esri/mapservice)
        var layer = _this.getPreviewLayer();

        // add layer to map
        if (_this.addPreviewLayer(layer)) {

          // add control if layer is added
          _this.addOpacityControl();
        }
      }
    });
  },

  addPreviewLayer: function(layer) {

    // if not null, add layer to map
    if (layer) {
      this.overlay.addLayer(layer);
      return true;
    }
  },

  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  }
});
