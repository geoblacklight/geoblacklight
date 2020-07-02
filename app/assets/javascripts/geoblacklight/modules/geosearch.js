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
    var sw = bounds.getSouthWest(),
        ne = bounds.getNorthEast();

    if ((ne.lng - sw.lng) >= 360) {
      sw.lng = -180;
      ne.lng = 180;
    }
    sw = sw.wrap();
    ne = ne.wrap();
    return [
      L.Util.formatNum(sw.lng, 6),
      L.Util.formatNum(sw.lat, 6),
      L.Util.formatNum(ne.lng, 6),
      L.Util.formatNum(ne.lat, 6)
    ];
  };

  L.Control.GeoSearch = L.Control.extend({

    options: {
      dynamic: true,
      baseUrl: '',
      searcher: function() {
        History.pushState(null, document.title, this.getSearchUrl());
      },
      delay: 800,
      staticButton: '<a href="#" class="btn btn-primary">Redo search here <span class="glyphicon glyphicon-repeat"></span></a>',
      dynamicButton: '<label><input type="checkbox" checked> Search when I move the map</label>'
    },

    initialize: function(options) {
      L.Util.setOptions(this, options);
      this.$staticButton = $(this.options.staticButton);
      this.$dynamicButton = $(this.options.dynamicButton);
    },

    onAdd: function(map) {
      var $container = $('<div class="leaflet-control search-control"></div>'),
          staticSearcher, dynamicSearcher;
      this._map = map;

      staticSearcher = L.Util.bind(function() {
        this.$staticButton.hide();
        this.$dynamicButton.show();
        this.options.searcher.apply(this);
      }, this);

      dynamicSearcher = GeoBlacklight.debounce(function() {
        if (this.options.dynamic) {
          this.options.searcher.apply(this);
        }
      }, this.options.delay);

      this.$staticButton.on('click', staticSearcher);

      $container.on("change", "input[type=checkbox]",
        L.Util.bind(function() {
          this.options.dynamic = !this.options.dynamic;
        }, this)
      );

      if (this.options.dynamic) {
        this.$staticButton.hide();
      } else {
        this.$dynamicButton.hide();
      }

      this.wasResized = false;
      map.on("resize", function(event) {
        this.wasResized = true;
      }, this);

      map.on("moveend", function(event) {
        if (this.wasResized) {
          this.wasResized = false;
        } else {
          dynamicSearcher.apply(this);
        }
      }, this);

      map.on("movestart", function() {
        if (!this.options.dynamic) {
          this.$dynamicButton.hide();
          this.$staticButton.show();
        }
      }, this);

      $container.append(this.$staticButton, this.$dynamicButton);
      return $container.get(0);
    },

    getSearchUrl: function() {
      var params = this.filterParams(['bbox', 'page']),
          bounds = L.boundsToBbox(this._map.getBounds());

      params.push('bbox=' + encodeURIComponent(bounds.join(' ')));
      return this.options.baseUrl + '?' + params.join('&');
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

  L.control.geosearch = function(options) {
    return new L.Control.GeoSearch(options);
  };

}(this);
