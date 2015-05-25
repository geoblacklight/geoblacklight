//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Esrimapservice = GeoBlacklight.Viewer.Map.extend({

  load: function() {
    this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.available) {
      this.addPreviewLayer();
      this.addOpacityControl();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  addPreviewLayer: function() {

    // set options
    var options = { opacity: 1 };

    // remove any trailing slash and split endpoint url
    var pathArray = this.data.url.replace(/\/$/, "").split('/');
    var lastSegment = pathArray[pathArray.length - 1];
    var EsrimapserviceLayer;

    // if last segment is an integer, treat as feature layer
    if (Number(lastSegment) === parseInt(lastSegment, 10)) {

      /**
        * TODO: update default styles to be more pleasing
        *       - will probably need to get layer info via ajax call (?f=json)
        *       - parse geometryType and set styles accordingly
      */
      EsrimapserviceLayer = L.esri.featureLayer(this.data.url, options);

      // feature layers can have inspection
      this.setupInspection();
    } else if (lastSegment === 'MapServer') {

      /**
        * FIXME: check for correct spatial reference
        * TODO:  perhaps allow non-mercator projections
        *         - use Proj4Leaflet
        *         - get layer info via ajax call (?f=json)
      */ 
      EsrimapserviceLayer = L.esri.tiledMapLayer(this.data.url, options);
    } else if (lastSegment === 'ImageServer') {
      EsrimapserviceLayer = L.esri.imageMapLayer(this.data.url, options);
    }

    // if it exists, add layer to map
    if (EsrimapserviceLayer) { this.overlay.addLayer(EsrimapserviceLayer); }
  },

  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  },

  setupInspection: function() {
    // TODO: setup feature layer inspection
  }
});
