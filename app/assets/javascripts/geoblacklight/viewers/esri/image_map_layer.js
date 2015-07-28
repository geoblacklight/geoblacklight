//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.ImageMapLayer = GeoBlacklight.Viewer.Esri.extend({
  layerInfo: {},

  getPreviewLayer: function() {

    // set layer url
    this.layerOptions.url = this.data.url;

    // return image service layer
    return L.esri.imageMapLayer(this.layerOptions);
  }
});
