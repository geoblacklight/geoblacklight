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
    L.esri.get(_this.data.url, {}, function(error, response){
      if(!error) {
        _this.layerInfo = response;

        // get layer as defined in submodules (e.g. esri/mapservice)
        var layer = _this.getPreviewLayer();

        // add layer to map
        if (_this.addPreviewLayer(layer)) {
          // add controls if layer is added
          _this.loadControls();
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

  // clear attribute table and setup spinner icon
  appendLoadingMessage: function() {
    var spinner = '<tbody class="attribute-table-body"><tr><td colspan="2">' +
      '<span id="attribute-table">' +
      '<i class="fa fa-spinner fa-spin fa-align-center">' +
      '</i></span>' +
      '</td></tr></tbody>';

    $('.attribute-table-body').html(spinner);
  },

  // appends error message to attribute table
  appendErrorMessage: function() {
    $('.attribute-table-body').html('<tbody class="attribute-table-body">'+
      '<tr><td colspan="2">Could not find that feature</td></tr></tbody>');
  },

  // populates attribute table with feature properties
  populateAttributeTable: function(feature) {
    var html = $('<tbody class="attribute-table-body"></tbody>');

    // step through properties and append to table
    for (var property in feature.properties) {
      html.append('<tr><td>' + property + '</td>'+
                  '<td>' + GeoBlacklight.Util.linkify(feature.properties[property]) + '</tr>');
    }
    $('.attribute-table-body').replaceWith(html);
  }
});
