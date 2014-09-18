Blacklight.onLoad(function() {
  $('[data-map="index"]').each(function(i, element) {
    var indexMap = new GeoBlacklight.Index(element);
  });
});

GeoBlacklight.Index = function(element) {
  var self = this;
  L.extend(self, GeoBlacklight.setupMap(element));

  self.map.options.catalogPath = L.DomUtil.get('map').dataset.catalogPath;
  self.bboxLayers = new L.layerGroup()
    .addTo(self.map);
  self.setHoverListeners();
};

GeoBlacklight.Index.prototype = {
  setHoverListeners: function() {
    var self = this;
    $('[data-layer-id]').on('mouseover', function(e){
      var bounds = GeoBlacklight.bboxToBounds(
        $(e.currentTarget).data('bbox')
      );
      
      var bboxLayer = L.polygon([bounds.getSouthWest(), bounds.getSouthEast(), bounds.getNorthEast(), bounds.getNorthWest()]);
      self.bboxLayers.addLayer(bboxLayer);
    });
    
    $('[data-layer-id]').on('mouseout', function(){
      self.bboxLayers.clearLayers();
    });
    
  }
};