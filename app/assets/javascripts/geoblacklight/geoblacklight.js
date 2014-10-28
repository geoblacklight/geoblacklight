!function(global) {
  'use strict';

  var throttled_search, map, overlay;

  function initialize(el) {
    var params = getParams(),
        basemap;

    basemap = L.tileLayer(
      'http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
        maxZoom: 18,
        worldCopyJump: true,
        subdomains: '1234' // see http://developer.mapquest.com/web/products/open/map
      }
    );

    overlay = L.layerGroup();

    if (typeof map !== "undefined" && 'remove' in map) {
      map.remove();
    }

    map = L.map(el);
    map.addLayer(basemap);
    map.addLayer(overlay);

    if ("center" in params && "z" in params) {
      map.setView(params.center[0].split(","), params.z[0]);
    } else {
      map.setView([0,0], 2);
    }

    map.on("moveend", _.partial(throttled_search, map, $(el).data()));

    return this;

  }

  /**
   * Turns querystring params into an object of key/values pairs.
   * @return {Object} Since any particular key may appear more than once, all
   *                  all values are returned as an array
   */
  function getParams() {
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
  }

  /**
   * Initiate new GeoBlacklight search.
   *
   * This uses Turbolinks.visit() to direct the user to a new URL, triggering a
   * new search. This function should probably be throttled, rather than being
   * called directly. See throttled_search().
   * @param  {L.Map}  map  Leaflet Map object
   * @param  {Object} data Data attributes from element map is attached to
   */
  function search(map, data) {
    var params = getParams(),
        bounds = boundsToBbox(map.getBounds()).join(' '),
        center = map.getCenter(),
        url;

    params.bbox = bounds;
    params.center = center.lat + ',' + center.lng;
    params.z = map.getZoom();
    url = data.catalogPath + '?' + $.param(params, false);
    Turbolinks.visit(url);
  }

  /**
   * Provides a throttled implementation of the search() function.
   */
  throttled_search = _.throttle(function(map, data) {
    search(map, data);
  }, 100, { leading: false });

  /**
   * Convert LatLngBounds to array of values.
   *
   * Additionally, this will wrap the longitude values for the corners.
   * @param  {L.LatLngBounds} bounds Leaflet LatLngBounds object
   * @return {Array}          Array of values as [sw.x, sw.y, ne.x, ne.y]
   */
  function boundsToBbox(bounds) {
    var sw = bounds.getSouthWest().wrap(),
        ne = bounds.getNorthEast().wrap();
    return [
      L.Util.formatNum(sw.lng, 6),
      L.Util.formatNum(sw.lat, 6),
      L.Util.formatNum(ne.lng, 6),
      L.Util.formatNum(ne.lat, 6)
    ];
  }

  /**
   * Convert bounding box string to Leaflet LatLngBounds.
   * @param  {String} bbox Space-separated string of sw-lng sw-lat ne-lng ne-lat
   * @return {L.LatLngBounds}      Converted Leaflet LatLngBounds object
   */
  function bboxToBounds(bbox) {
    bbox = bbox.split(' ');
    if (bbox.length === 4) {
      return L.latLngBounds([[bbox[1], bbox[0]], [bbox[3], bbox[2]]]);
    } else {
      return null;
    }
  }

  /**
   * Add a bounding box overlay to map.
   * @param {L.LatLngBounds} bounds Leaflet LatLngBounds
   */
  function addBoundsOverlay(bounds) {
    if (bounds instanceof L.LatLngBounds) {
      overlay.addLayer(L.polygon([
        bounds.getSouthWest(),
        bounds.getSouthEast(),
        bounds.getNorthEast(),
        bounds.getNorthWest()
      ]));
    }
  }

  /**
   * Remove bounding box overlay from map.
   */
  function removeBoundsOverlay() {
    overlay.clearLayers();
  }

  global.GeoBlacklight = {
    __version__: '0.0.1',
    initialize: initialize,
    bboxToBounds: bboxToBounds,
    addBoundsOverlay: addBoundsOverlay,
    removeBoundsOverlay: removeBoundsOverlay
  };

}(this);
