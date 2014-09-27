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
    _this.setupInspection();
  },
  addBboxLayer: function() {
    var _this = this;
    _this.bounds = GeoBlacklight.bboxToBounds(
      _this.element.dataset.mapBbox
    );
    _this.bboxLayer = L.polygon([_this.bounds.getSouthWest(), _this.bounds.getSouthEast(), _this.bounds.getNorthEast(), _this.bounds.getNorthWest()]);
    _this.layer.addLayer(_this.bboxLayer);
  },
  setupInspection: function() {
    var _this = this;
    _this.map.on('click', function(e) {
      spinner = '<span id="attribute-table"><i class="fa fa-spinner fa-spin fa-3x fa-align-center"></i></span>';
      $('#attribute-table').replaceWith(spinner);
      var wmsoptions = {
        URL: _this.dataAttributes.wmsUrl,
        LAYERS: _this.dataAttributes.layerId,
        BBOX: _this.map.getBounds().toBBoxString(),
        WIDTH: $('#map').width(),
        HEIGHT: $('#map').height(),
        QUERY_LAYERS: _this.dataAttributes.layerId,
        X: Math.round(e.containerPoint.x),
        Y: Math.round(e.containerPoint.y)
      };

      $.ajax({
        type: 'POST',
        url: '/wms/handle',
        data: wmsoptions,
        success: function(data) {
          if (data.hasOwnProperty('error')) {
            $('#attribute-table').html('Could not find that feature');
            return;
          }
          var t = $('<table id="attribute-table" class="table table-hover table-condensed table-responsive table-striped table-bordered"><thead><tr><th>Attribute</th><th>Value</th></tr></thead><tbody>');
          $.each(data.values, function(i,val) {
            t.append('<tr><td>' + val[0] + '</td><td>' + val[1] + '</tr>');
          });
          $('#attribute-table').replaceWith(t);
        },
        fail: function(error) {
          console.log(error);
        }
      });
    });
  }
};
