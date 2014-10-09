var GeoBlacklight = {
  version: '0.0.1'
};

GeoBlacklight = function(){
  var self = this;
  self.params = self.getParams();
};

GeoBlacklight.prototype = {
  setupMap: function(element){
    var self = this,
        basemap;

    basemap = L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
      maxZoom: 18,
      worldCopyJump: true,
      subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
    });

    self.dataAttributes = $(element).data();
    if (self.dataAttributes.mapBbox) {
      self.bounds = self.bboxToBounds(self.dataAttributes.mapBbox);
    }
    self.map = L.map('map');
    basemap.addTo(self.map);
    self.searchControl = L.searchButton(self);

    if (self.bounds){
      self.map.fitBounds(self.bounds);
    }else{
      self.map.setZoom(2);
      self.map.setView([0,0]);
    }

    return {
      map: self.map,
      searchControl: self.searchControl,
      params: self.params,
      dataAttributes: self.dataAttributes
    };
  },

  searchFromBounds: function() {
    var self = this;
    self.params.bbox = GeoBlacklight.boundsToBbox(self._map.getBounds()).join(' ');
    window.location = self._map.options.catalogPath + '?' +
      $.param(self.params, false);
  },

  getParams: function() {
    var queryDict = {},
        search = window.location.search.substr(1);

    $.each(search.split('&'), function(index, item) {
      var param = item.split("="),
          key = param[0],
          value = param[1];

      if (!key && !value) {
        return;
      }

      key = decodeURIComponent(key).replace(/\[\]$/, '');
      value = decodeURIComponent(value);

      if (queryDict[key] !== undefined) {
        queryDict[key].push(value);
      } else {
        queryDict[key] = [value];
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
    if (bbox.length === 4) {
      return L.latLngBounds([[bbox[1], bbox[0]], [bbox[3], bbox[2]]]);
    }else {
      return null;
    }
  },
  boundsToBbox: function(bounds) {
    var minx = L.forNum(bounds._southWest.lng, 6),
        maxx = L.forNum(bounds._northEast.lng, 6);
    minx = GeoBlacklight.wrapLng(minx);
    maxx = GeoBlacklight.wrapLng(maxx);

    return [minx, L.forNum(bounds._southWest.lat, 6), maxx, L.forNum(bounds._northEast.lat, 6)];
  },
  boundsToEnvelope: function(bounds){
    return [L.forNum(bounds._southWest.lng, 6), L.forNum(bounds._northEast.lng, 6), L.forNum(bounds._northEast.lat, 6), L.forNum(bounds._southWest.lat, 6)].join(',');
  },

  wrapLng: function(lng) {
    while (lng < -180) {
      lng += 360;
    }
    while (lng > 180) {
      lng -= 360;
    }
    return lng;
  }
};

GeoBlacklight = new GeoBlacklight();