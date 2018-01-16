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
              weight: 1
            }
            // Style the colors based on availability
            if (feature.properties.available) {
              style.color = '#1eb300';
            } else {
              style.color = '#b3001e';
            }
            return style;
          },
          onEachFeature: function(feature, layer) {
            // Add a hover label for the label property
            if (feature.properties.label !== null) {
              layer.bindLabel(feature.properties.label, {
                direction: 'auto', permanent: true
              });
            }
            // If it is available add clickable info
            if (feature.properties.available !== null) {
              layer.on('click', function(e) {
                GeoBlacklight.Util.indexMapTemplate(feature.properties, function(html) {
                  $('.viewer-information').html(html);
                });
              });
            }
          }
        }).addTo(_this.map);
        _this.map.fitBounds(geoJSONLayer.getBounds());
    });
  }
});
