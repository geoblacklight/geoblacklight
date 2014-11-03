!function(global) {
  'use strict';

  /**
   * Convert bounding box string to Leaflet LatLngBounds.
   * @param {String} bbox Space-separated string of sw-lng sw-lat ne-lng ne-lat
   * @return {L.LatLngBounds} Converted Leaflet LatLngBounds object
   */
  L.bboxToBounds = function(bbox) {
    bbox = bbox.split(' ');
    if (bbox.length === 4) {
      return L.latLngBounds([[bbox[1], bbox[0]], [bbox[3], bbox[2]]]);
    } else {
      return null;
    }
  };

  var GeoBlacklight = L.Class.extend({

    statics: {
      __version__: '0.0.1'
    },

    initialize: function(el) {
      var data = $(el).data() || {},
          center, zoom, basemap, map;

      basemap = L.tileLayer(
        'http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
          maxZoom: 18,
          worldCopyJump: true,
          subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
        }
      );

      this.overlay = L.layerGroup();

      map = L.map(el);
      this.map = map;
      map.addLayer(basemap);
      map.addLayer(this.overlay);

      if (typeof data.mapCenter === "string" && typeof data.mapZoom === "number") {
        center = $.map(data.mapCenter.split(" "), function(num) {
          return parseFloat(num);
        });
        zoom = parseInt(data.mapZoom, 10);
        map.setView(center, zoom);
      } else {
        map.setView([0,0], 2);
      }
    },

    /**
     * Add a bounding box overlay to map.
     * @param {L.LatLngBounds} bounds Leaflet LatLngBounds
     */
    addBoundsOverlay: function(bounds) {
      if (bounds instanceof L.LatLngBounds) {
        this.overlay.addLayer(L.polygon([
          bounds.getSouthWest(),
          bounds.getSouthEast(),
          bounds.getNorthEast(),
          bounds.getNorthWest()
        ]));
      }
    },

    /**
     * Remove bounding box overlay from map.
     */
    removeBoundsOverlay: function() {
      this.overlay.clearLayers();
    }

  });

  global.GeoBlacklight = GeoBlacklight;

}(this);
