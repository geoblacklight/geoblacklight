Blacklight.onLoad(function() {
  $('[data-map="item"]').each(function(i, element) {
    var layerMap = new GeoBlacklight.Item(element);
  });
});

GeoBlacklight.Item = function(element) {
  var _this = this;
  _this.element = element;
  L.extend(_this, GeoBlacklight.setupMap(element));
  _this.map.options.catalogPath = _this.dataAttributes.catalogPath;
  _this.layer = new L.layerGroup()
    .addTo(_this.map);
  if (_this.dataAttributes.available) {
    _this.addPreviewLayer();
  } else {
    _this.addBboxLayer();
  }
};

GeoBlacklight.Item.prototype = {
  addPreviewLayer: function() {
    var _this = this;
    _this.wmsLayer = L.tileLayer.wms(_this.dataAttributes.wmsUrl, {
      layers: _this.dataAttributes.layerId,
      format: 'image/png',
      transparent: true,
      tiled: true,
      CRS: 'EPSG:900913',
      opacity: 0.75
    });
    _this.layer.addLayer(_this.wmsLayer);
  },
  addBboxLayer: function() {
    var _this = this;
    _this.bounds = GeoBlacklight.bboxToBounds(
      _this.element.dataset.mapBbox
    );
    _this.bboxLayer = L.polygon([_this.bounds.getSouthWest(), _this.bounds.getSouthEast(), _this.bounds.getNorthEast(), _this.bounds.getNorthWest()]);
    _this.layer.addLayer(_this.bboxLayer);
  }
};
