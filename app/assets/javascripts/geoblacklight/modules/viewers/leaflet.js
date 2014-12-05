 // leaflet viewer
 modulejs.define('viewer/leaflet', ['viewer/viewer'], function(Viewer) {
   function Leaflet(el) {
     Viewer.apply(this, arguments);

     this.options = {
        /**
         * Initial bounds of map
         * @type {L.LatLngBounds}
         */
         bbox: [[-85, -180], [85, 180]]
       };

       this.basemap = L.tileLayer(
        'https://otile{s}-s.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="//developer.mapquest.com/content/osm/mq_logo.png">',
          maxZoom: 18,
          worldCopyJump: true,
        subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
      });

       this.overlay = L.layerGroup();
     };

     Leaflet.prototype = Object.create(Viewer.prototype);

     Leaflet.prototype.addBoundsOverlay = function (bounds) {
      if (bounds instanceof L.LatLngBounds) {
        this.overlay.addLayer(L.polygon([
          bounds.getSouthWest(),
          bounds.getSouthEast(),
          bounds.getNorthEast(),
          bounds.getNorthWest()
          ]));
      }
    };

    Leaflet.prototype.removeBoundsOverlay = function() {
      this.overlay.clearLayers();
    };

    Leaflet.prototype.load = function ()  {
      if (this.data.mapBbox) {
        this.options.bbox = L.bboxToBounds(this.data.mapBbox);
        this.map = L.map(this.element).fitBounds(this.options.bbox);
        this.map.addLayer(this.basemap);
        this.map.addLayer(this.overlay);
        this.addBoundsOverlay(this.options.bbox);
      }
    };

    return Leaflet;
  });