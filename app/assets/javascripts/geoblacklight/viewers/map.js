//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Map = GeoBlacklight.Viewer.extend({
  options: {
    /**
    * Initial bounds of map
    * @type {L.LatLngBounds}
    */
    opacity: 0.75,
    geojson: L.geoJson({"type":"Polygon","coordinates":[[[-195,-80],[-195,80],[185,80],[185,-80],[-195,-80]]]}),
  },

  overlay: L.layerGroup(),

  load: function() {
    if (this.data.mapGeojson) {
      this.options.geojson = L.geoJson(this.data.mapGeojson);
    }
    this.map = L.map(this.element).fitBounds(this.options.geojson);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.map !== 'index' && this.data.map !== 'home' ) {
      this.map.addLayer(this.options.geojson);
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

  addGeoJsonOverlay: function(geojson) {
    this.overlay.addLayer(geojson);
  },

  /**
   * Remove bounding box overlay from map.
   */
  removeBoundsOverlay: function() {
    this.overlay.clearLayers();
  },

  /**
  * Selects basemap if specified in data options, if not return positron.
  */
  selectBasemap: function() {
    var _this = this;
    if (_this.data.basemap) {
      return GeoBlacklight.Basemaps[_this.data.basemap];
    } else {
      return GeoBlacklight.Basemaps.positron;
    }
  }
});
