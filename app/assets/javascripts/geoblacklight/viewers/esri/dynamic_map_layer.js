//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.DynamicMapLayer = GeoBlacklight.Viewer.Esri.extend({

  // override to parse between dynamic layer types
  getEsriLayer: function() {
    var _this = this;

    // remove any trailing slash from endpoint url
    _this.data.url = _this.data.url.replace(/\/$/, '');

    // get last segment from url
    var pathArray = this.data.url.replace(/\/$/, '').split('/');
    var lastSegment = pathArray[pathArray.length - 1];

    // if the last seg is an integer, slice and save as dynamicLayerId
    if (Number(lastSegment) === parseInt(lastSegment, 10)) {
      this.dynamicLayerId = lastSegment;
      this.data.url = this.data.url.slice(0,-(lastSegment.length + 1));
    }

    L.esri.get(_this.data.url, {}, function(error, response){
      if(!error) {
        _this.layerInfo = response;

        // get layer
        var layer = _this.getPreviewLayer();

        // add layer to map
        if (_this.addPreviewLayer(layer)) {

          // add controls if layer is added
          _this.loadControls();
        }
      }
    });
  },

  getPreviewLayer: function() {

    // set layer url
    this.options.url = this.data.url;

    // show only single layer, if specified
    if (this.dynamicLayerId) {
      this.options.layers = [this.dynamicLayerId];
    }

    var esriDynamicMapLayer = L.esri.dynamicMapLayer(this.options);

    // setup feature inspection
    this.setupInspection(esriDynamicMapLayer);
    return esriDynamicMapLayer;
  },

  setupInspection: function(layer) {
    var _this = this;
    this.map.on('click', function(e) {
      _this.appendLoadingMessage();

      // query layer at click location
      var identify = L.esri.identifyFeatures({
          url: layer.options.url,
          useCors: true
      })
        .tolerance(2)
        .returnGeometry(false)
        .on(_this.map)
        .at(e.latlng);

      // query specific layer if dynamicLayerId is set
      if (_this.dynamicLayerId) {
        identify.layers('all: ' + _this.dynamicLayerId);
      }

      identify.run(function(error, featureCollection, response){
        if (error || response['results'] < 1) {
          _this.appendErrorMessage();
        } else {
          _this.populateAttributeTable(featureCollection.features[0]);
        }
      });
    });
  }
});
