//= require geoblacklight/viewers/viewer.js

GeoBlacklight.Viewer.Leaflet = GeoBlacklight.Viewer.extend({
  basemap: L.tileLayer(
    'https://otile{s}-s.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="//developer.mapquest.com/content/osm/mq_logo.png">',
    maxZoom: 18,
    worldCopyJump: true,
    subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
    }
  ),

  overlay: L.layerGroup(),

  load: function() {
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.basemap);
    this.map.addLayer(this.overlay);
    this.addBoundsOverlay(this.options.bbox);
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