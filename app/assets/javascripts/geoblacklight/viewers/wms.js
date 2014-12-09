//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Wms = GeoBlacklight.Viewer.Map.extend({

  load: function() {
    this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.basemap);
    this.map.addLayer(this.overlay);

    if (this.data.available) {
      this.addPreviewLayer();
      this.addOpacityControl();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  addPreviewLayer: function() {
    var wmsLayer = L.tileLayer.wms(this.data.url, {
      layers: this.data.layerId,
      format: 'image/png',
      transparent: true,
      tiled: true,
      CRS: 'EPSG:900913',
      opacity: 0.75
    });
    this.overlay.addLayer(wmsLayer);
    this.setupInspection();
  },

  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  },

  setupInspection: function() {
    var _this = this;
    this.map.on('click', function(e) {
      spinner = '<span id="attribute-table"><i class="fa fa-spinner fa-spin fa-3x fa-align-center"></i></span>';
      $('#attribute-table').replaceWith(spinner);
      var wmsoptions = {
        URL: _this.data.url,
        LAYERS: _this.data.layerId,
        BBOX: _this.map.getBounds().toBBoxString(),
        WIDTH: $('#map').width(),
        HEIGHT: $('#map').height(),
        QUERY_LAYERS: _this.data.layerId,
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
          $.each(data.values, function(i, val) {
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
});
