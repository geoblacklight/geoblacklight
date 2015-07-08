//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.Featureservice = GeoBlacklight.Viewer.Esri.extend({

  // default feature styles
  defaultStyles: {
      'esriGeometryPoint': '', 
      'esriGeometryMultipoint': '',
      'esriGeometryPolyline': {color: 'blue', weight: 3 },
      'esriGeometryPolygon': {color: 'blue', weight: 2 }
  },

  getPreviewLayer: function() {

    // set esri leaflet options
    var options = { opacity: 1 }

    // set default style
    options.style = this.getFeatureStyle();
    var esriFeatureLayer = L.esri.featureLayer(this.data.url, options);

    // feature layers can have inspection
    this.setupInspection();

    // return image service layer
    return esriFeatureLayer;
  },
  
  getFeatureStyle: function() {
    var _this = this;

    // lookup style hash based on layer geometry type and return function
    return function(feature) { return _this.defaultStyles[_this.layerInfo.geometryType]; };
  },

  setupInspection: function() {
    // TODO: setup feature layer inspection
  }
});
