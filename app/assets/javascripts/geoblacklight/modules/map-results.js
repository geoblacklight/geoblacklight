'use strict';
console.log('DEBUG: Inside geoblacklight/modules/map-results.js');

Blacklight.onLoad(function () {
  $('#geoblacklight-map-results').geoBlacklight_setupMapResults();
});

/* Requires leaflet */
(function( $ ) {

  $.fn.geoBlacklight_setupMapResults = function () {
    console.log(this)
      return this.each(function () {
      var map = L.map('map');
      var basemap = L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
        maxZoom: 18
      }).addTo(map);
      map.setView([0,0],1);
      console.log(mapBbox);
      map.fitBounds(mapBbox);      
    })
  };
  
  $.fn.geoBlacklight_computeBbox = function (i) {
    var doc = solrDocs[i];
    //Calculates map bounding box and creates layer bbox
    if (doc.solr_bbox){
      bBoxs[i] = L.polygon([
        [doc.solr_sw_pt_0_d, doc.solr_sw_pt_1_d], 
        [doc.solr_ne_pt_0_d, doc.solr_sw_pt_1_d], 
        [doc.solr_ne_pt_0_d, doc.solr_ne_pt_1_d], 
        [doc.solr_sw_pt_0_d, doc.solr_ne_pt_1_d]]);

      if (mapBbox.length == 0) {
        mapBbox = [[doc.solr_sw_pt_0_d, doc.solr_sw_pt_1_d], 
                   [doc.solr_ne_pt_0_d, doc.solr_ne_pt_1_d]];
      } else{
        if (doc.solr_sw_pt_0_d < mapBbox[0][0]){
          mapBbox[0][0] = doc.solr_sw_pt_0_d;
        }
        if (doc.solr_sw_pt_1_d < mapBbox[0][1]){
          mapBbox[0][1] = doc.solr_sw_pt_1_d;
        }
        if (doc.solr_ne_pt_0_d > mapBbox[1][0]){
          mapBbox[1][0] = doc.solr_ne_pt_0_d;
        }
        if (doc.solr_ne_pt_1_d > mapBbox[1][1]){
          mapBbox[1][1] = doc.solr_ne_pt_1_d;
        }
      }
    }
  }

})( jQuery );
