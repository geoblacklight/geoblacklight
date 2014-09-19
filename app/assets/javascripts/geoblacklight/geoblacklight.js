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
  self.params = self.getParams();
};

GeoBlacklight.prototype = {
  setupMap: function(element){
    var self = this;
    self.bounds = self.bboxToBounds(element.dataset.mapBbox);
    self.map = L.map('map');
    self.basemap.addTo(self.map);
    self.searchControl = L.searchButton(self);
    
    if (self.bounds){
      self.map.fitBounds(self.bounds);
    }else{
      self.map.setZoom(2);
      self.map.setView([0,0]);
    }
    // Needed to accomodate basemap not reloading with turbolinks enabled
    self.refreshBasemap();
    return {
      map: self.map, 
      basemap: self.basemap,
      searchControl: self.searchControl,
      params: self.params
    };
  },
  refreshBasemap: function() {
    var self = this;
    self.map.eachLayer(function(layer){
      self.map.removeLayer(layer);
    });
    self.basemap.addTo(self.map);
  },
  searchFromBounds: function() {
    var self = this;
    self.params.bbox = GeoBlacklight.boundsToBbox(self._map.getBounds()).join(' ');
    location = self._map.options.catalogPath + L.Util.getParamString(self.params);
  },
  getParams: function() {
    var queryDict = {};
    location.search.substr(1).split('&').forEach(function(item) {
      if (item.length > 0){
        queryDict[item.split('=')[0]] = item.split('=')[1];
      }
    });
    return queryDict;
  },
  // Conversion methods for envelope / bounds / bbox
  envelopeToBounds: function(string){
    var values = string.split(',');
    if (values.length === 4){
      return L.latLngBounds([[values[3], values[0]], [values[2], values[1]]]);
    }else{
      return null;
    }
  },
  bboxToBounds: function(bbox) {
    bbox = bbox.split(' ');
    if (bbox.length === 4){
      return L.latLngBounds([[bbox[1], bbox[0]], [bbox[3], bbox[2]]]);
    }else{
      return null;
    }
  },
  boundsToBbox: function(bounds) {
    return [L.forNum(bounds._southWest.lng, 6), L.forNum(bounds._southWest.lat, 6), L.forNum(bounds._northEast.lng, 6), L.forNum(bounds._northEast.lat, 6)];
  },
  boundsToEnvelope: function(bounds){
    return [L.forNum(bounds._southWest.lng, 6), L.forNum(bounds._northEast.lng, 6), L.forNum(bounds._northEast.lat, 6), L.forNum(bounds._southWest.lat, 6)].join(',');
  }
};

GeoBlacklight = new GeoBlacklight();