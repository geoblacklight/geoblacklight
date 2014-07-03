'use strict';

console.log('DEBUG: Inside geoblacklight/modules/map-home.js');

Blacklight.onLoad(function () {
  $('#geoblacklight-map-home').geoBlacklight_setupMapHome();
});

/* Requires leaflet */
(function( $ ) {

  $.fn.geoBlacklight_setupMapHome = function () {
    console.log(this)
    return this.each(function () {
      var map = L.map('map');

      var basemap = L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
        maxZoom: 18,
        subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
      }).addTo(map);
      map.setZoom(2);
      map.setView([0,0]);
    })
  };

})( jQuery );