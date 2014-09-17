Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element){
    home = new GeoBlacklight.Home(element);
  });
});

GeoBlacklight.Home = function(element){
  var self = this;
  L.extend(self, GeoBlacklight.setupMap(element));
  self.map.options.catalogPath = element.dataset.catalogPath;

};

GeoBlacklight.Home.prototype = {

};