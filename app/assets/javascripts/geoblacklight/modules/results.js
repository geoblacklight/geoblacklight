Blacklight.onLoad( function() {
  $('[data-map="index"]').each(function(i, element) {
    var resultsMap = new GeoBlacklight.Results(element);
  });
});

GeoBlacklight.Results = function(element) {
  var self = this;
  L.extend(self, GeoBlacklight.setupMap(element));
  self.map.options.catalogPath = self.dataAttributes.catalogPath;
  self.bboxLayers = new L.layerGroup()
    .addTo(self.map);
  self.setHoverListeners();
};

GeoBlacklight.Results.prototype = {
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