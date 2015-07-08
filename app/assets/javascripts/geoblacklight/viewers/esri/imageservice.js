//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.Imageservice = GeoBlacklight.Viewer.Esri.extend({
  layerInfo: {},

  getPreviewLayer: function() {

    // set esri leaflet options
    var options = { opacity: 1 }

    // return image service layer
    return L.esri.imageMapLayer(this.data.url, options);
  }
});
