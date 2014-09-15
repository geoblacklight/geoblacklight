var GeoBlacklight = {
  version: '0.0.1'
};

GeoBlacklight = function(){
  var self = this;
  self.basemap = L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
    maxZoom: 18,
    worldCopyJump: true,
    subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
  });
};
var c;
GeoBlacklight.prototype = {
  setupMap: function(element){
    var self = this;
    self.bounds = self.bboxToBounds(element.dataset.mapBbox);
    self.map = L.map('map');
    self.basemap.addTo(self.map);
    if (self.bounds){
      self.map.fitBounds(self.bounds);
    }else{
      self.map.setZoom(2);
      self.map.setView([0,0]);
    }
    return {
      map: self.map, 
      basemap: self.basemap
    };
  },
  bboxToBounds: function(string){
    var values = string.split(',');
    if (values.length === 4){
      return L.latLngBounds([[values[3], values[0]], [values[2], values[1]]]);
    }else{
      return null;
    }
  },
  boundsToBbox: function(bounds){
    return [L.forNum(bounds._southWest.lng, 6), L.forNum(bounds._northEast.lng, 6), L.forNum(bounds._northEast.lat, 6), L.forNum(bounds._southWest.lat, 6)].join(',');
  }
};

GeoBlacklight = new GeoBlacklight();

L.forNum = L.Util.formatNum;