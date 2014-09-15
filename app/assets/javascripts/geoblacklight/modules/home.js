Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element){
    home = new GeoBlacklight.Home(element);
  });
});

GeoBlacklight.Home = function(element){
  var self = this;
  self.catalogPath = element.dataset.catalogPath;
  L.extend(self, GeoBlacklight.setupMap(element));
  self.setupMapListeners();
};

GeoBlacklight.Home.prototype = {
  setupMapListeners: function(){
    var self = this;
    // TODO this interaction isn't quite right. We need a plugin that fires a
    // custom event when a user is "finished" looking around (~1 sec?)
    self.moving = false;
    
    self.map.on('movestart', function(e){
      self.moving = true;
    });
    
    self.map.on('moveend', function(e){
      self.moving = false;
      window.setTimeout(function(){
        var bounds = GeoBlacklight.boundsToBbox(self.map.getBounds());
        if (!self.moving){
          //TODO Basics of adding bbox parameters for Solr to url - but needs work
          location = self.catalogPath + '?bbox=' + bounds;
        }
      }, 1000);
    });
  }
};