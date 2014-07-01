'use strict';

Blacklight.onLoad(function () {
  $('#geoblacklight-map').geoBlacklight_setupMap();
});

/* Requires leaflet */
(function( $, mapBbox ) {

  $.fn.geoBlacklight_setupMap = function () {
    var map = L.map(this).setView([0,0],1);
    var basemap = L.tileLayer('https://a.tiles.mapbox.com/v3/drh-stanford.ic5mf3lb/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
      maxZoom: 18
    }).addTo(map);
    map.fitBounds(mapBbox);
  };

})( jQuery, mapBbox );
