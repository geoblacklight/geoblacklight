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
      var basemap = L.tileLayer('https://a.tiles.mapbox.com/v3/drh-stanford.ic5mf3lb/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
        maxZoom: 18
      }).addTo(map);
      map.setZoom(1);
      map.setView([0,0]);
    })
  };

})( jQuery );