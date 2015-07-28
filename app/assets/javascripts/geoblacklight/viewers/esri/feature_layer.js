//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.FeatureLayer = GeoBlacklight.Viewer.Esri.extend({

  // default feature styles
  defaultStyles: {
    'esriGeometryPoint': '', 
    'esriGeometryMultipoint': '',
    'esriGeometryPolyline': {color: 'blue', weight: 3 },
    'esriGeometryPolygon': {color: 'blue', weight: 2 }
  },

  getPreviewLayer: function() {

    // set layer url
    this.layerOptions.url = this.data.url;

    // set default style
    this.layerOptions.style = this.getFeatureStyle();

    // define feature layer
    this.esriFeatureLayer = L.esri.featureLayer(this.layerOptions);

    //setup feature inspection and opacity
    this.setupInspection(this.esriFeatureLayer);
    this.setupInitialOpacity(this.esriFeatureLayer);

    return this.esriFeatureLayer;
  },

  // override opacity control because feature layer is special
  addOpacityControl: function() {

    // define setOpacity function that works for svg elements
    this.esriFeatureLayer.setOpacity = function(opacity) {
      $('.leaflet-clickable').css({ opacity: opacity });
    };

    // add new opacity control
    this.map.addControl(new L.Control.LayerOpacity(this.esriFeatureLayer));
  },

  getFeatureStyle: function() {
    var _this = this;

    // lookup style hash based on layer geometry type and return function
    return function(feature) { 
      return _this.defaultStyles[_this.layerInfo.geometryType]; 
    };
  },

  setupInitialOpacity: function(featureLayer) {
    featureLayer.on('load', function(e) {
      featureLayer.setOpacity(0.75);
    });
  },

  setupInspection: function(featureLayer) {
    var _this = this;

    // inspect on click    
    featureLayer.on('click', function(e) {
      _this.appendLoadingMessage();

      // query layer at click location
      featureLayer.query()
      .returnGeometry(false)
      .intersects(e.latlng)
      .run(function(error, featureCollection, response){
        if (error) {
          _this.appendErrorMessage();
        } else {
          _this.populateAttributeTable(featureCollection.features[0]);
        }
      });
    });
  }
});
