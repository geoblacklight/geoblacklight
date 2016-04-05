//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Wms = GeoBlacklight.Viewer.Map.extend({

  load: function() {
    this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);

    if (this.data.available) {
      this.addPreviewLayer();
      this.loadControls();
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
      opacity: this.options.opacity,
      detectRetina: true
    });
    this.overlay.addLayer(wmsLayer);
    this.setupInspection();
  },

  setupInspection: function() {
    var _this = this;
    this.map.on('click', function(e) {
      spinner = '<tbody class="attribute-table-body"><tr><td colspan="2"><span id="attribute-table"><i class="fa fa-spinner fa-spin fa-align-center"></i></span></td></tr></tbody>';
      $('.attribute-table-body').replaceWith(spinner);
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
          if (data.hasOwnProperty('error') || data.values.length === 0) {
            $('.attribute-table-body').html('<tbody class="attribute-table-body"><tr><td colspan="2">Could not find that feature</td></tr></tbody>');
            return;
          }
          var html = $('<tbody class="attribute-table-body"></tbody>');
          $.each(data.values, function(i, val) {
            html.append('<tr><td>' + val[0] + '</td><td>' + val[1] + '</tr>');
          });
          $('.attribute-table-body').replaceWith(html);
        },
        fail: function(error) {
          console.log(error);
        }
      });
    });
  }
});
