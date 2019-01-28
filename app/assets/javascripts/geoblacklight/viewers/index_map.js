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
    var style = {};
    var options = this.data.leafletOptions;

    // Style the colors based on availability
    if (availability || typeof(availability) === 'undefined') {
      style = options.LAYERS.INDEX.DEFAULT;
    } else {
      style = options.LAYERS.INDEX.UNAVAILABLE;
    }
    return style
  },
  addPreviewLayer: function() {
    var _this = this;
    var geoJSONLayer;
    var prevLayer = null;
    var options = this.data.leafletOptions;
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
                // Change currently selected layer color
                layer.setStyle(options.LAYERS.INDEX.SELECTED);
                // Change previously selected layer color to original color
                if (prevLayer !== null) {
                  geoJSONLayer.resetStyle(prevLayer);
                }
                prevLayer = layer;
                GeoBlacklight.Util.indexMapTemplate(feature.properties, function(html) {
                  $('.viewer-information').html(html);
                });
                GeoBlacklight.Util.indexMapDownloadTemplate(feature.properties, function(html) {
                  $('.js-index-map-feature').remove();
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