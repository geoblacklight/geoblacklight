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
  availabilityStyle: function(availability) {
    var style = {
      radius: 4,
      weight: 1,
    }
    // Style the colors based on availability
    if (typeof(availability) === 'undefined') {
      return style; // default Leaflet style colorings
    }

    if (availability) {
      style.color = '#1eb300';
    } else {
      style.color = '#b3001e';
    }
    return style
  },
  addPreviewLayer: function() {
    var _this = this;
    var geoJSONLayer;
    $.getJSON(this.data.url, function(data) {
      geoJSONLayer = L.geoJson(data,
        {
          style: function(feature) {
            return _this.availabilityStyle(feature.properties.available);
          },
          onEachFeature: function(feature, layer) {
            // Add a hover label for the label property
            if (feature.properties.label !== null) {
              layer.bindTooltip(feature.properties.label);
            }
            // If it is available add clickable info
            if (feature.properties.available !== null) {
              layer.on('click', function(e) {
                GeoBlacklight.Util.indexMapTemplate(feature.properties, function(html) {
                  $('.viewer-information').html(html);
                });
                GeoBlacklight.Util.indexMapDownloadTemplate(feature.properties, function(html) {
                  $('.js-index-map-item').remove();
                  $('.js-download-list').append(html);
                });
              });
            }
          },
          // For point index maps, use circle markers
          pointToLayer: function (feature, latlng) {
            return L.circleMarker(latlng);
          }
        }).addTo(_this.map);
        _this.map.fitBounds(geoJSONLayer.getBounds());
    });
  }
});
