//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Esrimapservice = GeoBlacklight.Viewer.Map.extend({
  layerInfo: {},

  // default feature styles
  defaultStyles: {
      'esriGeometryPoint': '',
      'esriGeometryMultipoint': '',
      'esriGeometryPolyline': {color: 'blue', weight: 3 },
      'esriGeometryPolygon': {color: 'blue', weight: 2 }
  },

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
    var url;

    // remove any trailing slash from endpoint url
    _this.data.url = _this.data.url.replace(/\/$/, '');

    // get layer info as json
    url = _this.data.url + '?f=json';
    $.getJSON(url, function(data) {
      _this.layerInfo = data;

      // add layer to map
      if (_this.addPreviewLayer()) {

        // add control if layer is added
        _this.addOpacityControl();
      }
    });
  },

  addPreviewLayer: function() {

    // set esri leaflet options
    var options = { opacity: 1 };

    // split endpoint url
    var pathArray = this.data.url.split('/');
    var lastSegment = pathArray[pathArray.length - 1];
    var esriMapServiceLayer;

    // parse url
    if (lastSegment === 'ImageServer') {
      esriMapServiceLayer = L.esri.imageMapLayer(this.data.url, options);
    } else if (lastSegment === 'MapServer') {

      // check for correct spatial reference
      if (this.layerInfo.spatialReference.wkid === 102100) {

        /**
          * TODO:  perhaps allow non-mercator projections and custom scales
          *        - use Proj4Leaflet
        */
        esriMapServiceLayer = L.esri.tiledMapLayer(this.data.url, options);
      }

    // if last path segment is an integer
    } else if (Number(lastSegment) === parseInt(lastSegment, 10)) {

      //  test if layer is feature layer
      if (this.layerInfo.type === 'Feature Layer') {

        // set default style
        options.style = this.getFeatureStyle();
        esriMapServiceLayer = L.esri.featureLayer(this.data.url, options);

        // feature layers can have inspection
        this.setupInspection();
      }
    }

    // if it exists, add layer to map
    if (esriMapServiceLayer) {
      this.overlay.addLayer(esriMapServiceLayer);
      return true;
    }
  },

  getFeatureStyle: function() {
    var _this = this;

    // lookup based on layer geometry type and return style hash
    return function(feature) { return _this.defaultStyles[_this.layerInfo.geometryType]; };
  },

  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  },

  setupInspection: function() {
    // TODO: setup feature layer inspection
  }
});
