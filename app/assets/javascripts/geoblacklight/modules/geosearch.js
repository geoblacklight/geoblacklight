!function(global) {
  "use strict";

  /**
   * Convert LatLngBounds to array of values.
   *
   * Additionally, this will wrap the longitude values for the corners.
   * @param {L.LatLngBounds} bounds Leaflet LatLngBounds object
   * @return {Array} Array of values as [sw.x, sw.y, ne.x, ne.y]
   */
  L.boundsToBbox = function(bounds) {
    var sw = bounds.getSouthWest().wrap(),
        ne = bounds.getNorthEast().wrap();
    return [
      L.Util.formatNum(sw.lng, 6),
      L.Util.formatNum(sw.lat, 6),
      L.Util.formatNum(ne.lng, 6),
      L.Util.formatNum(ne.lat, 6)
    ];
  };

  L.Control.GeoSearch = L.Control.extend({

    options: {
      button: false
    },

    initialize: function(searcher, options) {
      L.Util.setOptions(this, options);
      this._searcher = L.Util.bind(searcher, this);
    },

    onAdd: function(map) {
      var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
      this._map = map;

      if (this.options.button === true) {
        this.link = L.DomUtil.create('a', 'leaflet-bar-part search-control',
          container);
        this.link.href = '';
        this.icon = L.DomUtil.create('i', 'glyphicon glyphicon-search',
          this.link);
      }

      map.on("moveend", function() {
        var _this = this;
        window.setTimeout(function() {
          _this._search();
        }, 800);
      }, this);

      return container;
    },

    _search: function() {
      var params = this.filterParams(['bbox', 'center', 'zoom']),
          bounds = L.boundsToBbox(this._map.getBounds()),
          center = this._map.getCenter(),
          zoom = this._map.getZoom();

      params.push('bbox=' + encodeURIComponent(bounds.join(' ')));
      params.push('center=' + encodeURIComponent(center.lat + ' ' + center.lng));
      params.push('zoom=' + zoom);

      this._searcher(params.join('&'));
    },

    filterParams: function(filterList) {
      var querystring = window.location.search.substr(1),
          params = [];

      if (querystring !== "") {
        params = $.map(querystring.split('&'), function(value) {
          if ($.inArray(value.split('=')[0], filterList) > -1) {
            return null;
          } else {
            return value;
          }
        });
      }
      return params;
    }

  });

}(this);
