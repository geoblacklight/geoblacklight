//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.IndexMap = GeoBlacklight.Viewer.Map.extend({
  load: function() {
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    
    if (this.data.available) {
      this.addPreviewLayer();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  addPreviewLayer: function() {
    var _this = this;
    var geoJSONLayer;
    $.getJSON(this.data.url, function(data) {
      geoJSONLayer = L.geoJson(data,
        {
          style: function(feature) {
            var style = {
              weight: 1,
              color: '#1eb300',
            }
            var title = feature.properties.Title
            if (title === null) {
              style.color = '#b3001e'
            }
            return style;
          },
          onEachFeature: function(feature, layer) {
            layer.bindLabel(feature.properties.Sheet_Num, {
              direction: 'auto', permanent: true
            });
            if (feature.properties.Title !== null) {
              layer.on('click', function(e) {
                console.log(e)
                var html = '';
                $.each(feature.properties, function(key, val) {
                  html += key + ': ' + val + '\n';
                });
                $('.viewer-information').html(html);
              });
            }
          }
        }).addTo(_this.map);
        _this.map.fitBounds(geoJSONLayer.getBounds());
    });
  }
});
