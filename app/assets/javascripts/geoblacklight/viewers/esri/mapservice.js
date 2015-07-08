//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.Mapservice = GeoBlacklight.Viewer.Esri.extend({
  
  getPreviewLayer: function() {

    // set esri leaflet options
    var options = { opacity: 1 };

    // check if this is a dynamic map service
    if (this.layerInfo.singleFusedMapCache === false && this.layerInfo.supportsDynamicLayers !== false) {
      return L.esri.dynamicMapLayer(this.data.url, options);

    // check if this is a tile map and layer and for correct spatial reference
    } else if (this.layerInfo.singleFusedMapCache === true && this.layerInfo.spatialReference.wkid === 102100) {

      /**
        * TODO:  perhaps allow non-mercator projections and custom scales
        *        - use Proj4Leaflet
      */
      return L.esri.tiledMapLayer(this.data.url, options);
    }
  }
});
