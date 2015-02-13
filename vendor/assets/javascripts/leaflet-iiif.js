/*
 * Leaflet-IIIF 0.0.5
 * IIIF Viewer for Leaflet
 * by Jack Reed, @mejackreed
 */

L.TileLayer.Iiif = L.TileLayer.extend({
  options: {
    continuousWorld: true,
    tileSize: 256,
    updateWhenIdle: true
  },

  initialize: function(url, options) {
    options = L.setOptions(this, options);
    this._infoDeferred = new $.Deferred();
    this._infoUrl = url;
    this._baseUrl = this._templateUrl();
    this._getInfo();
  },
  getTileUrl: function(coords) {
    var _this = this,
      x = coords.x,
      y = (coords.y),
      zoom = _this._map.getZoom(),
      scale = Math.pow(2, _this.maxZoom - zoom),
      tileBaseSize = _this.options.tileSize * scale,
      minx = (x * tileBaseSize),
      miny = (y * tileBaseSize),
      maxx = Math.min(minx + tileBaseSize, _this.x),
      maxy = Math.min(miny + tileBaseSize, _this.y);

    return L.Util.template(this._baseUrl, L.extend({
      format: 'jpg',
      quality: _this.quality,
      region: [minx, miny, (maxx - minx), (maxy - miny)].join(','),
      rotation: 0,
      size: 'pct:' + (100 / scale)
    }, this.options));
  },
  onAdd: function(map) {
    var _this = this;

    // Wait for deferred to complete
    $.when(_this._infoDeferred).done(function() {

      // Find best zoom level and center map
      var initialZoom = _this._getInitialZoom(map.getSize()),
        imageSize = _this._imageSizes[initialZoom],
        sw = map.options.crs.pointToLatLng(L.point(0, imageSize.y), initialZoom),
        ne = map.options.crs.pointToLatLng(L.point(imageSize.x, 0), initialZoom),
        bounds = L.latLngBounds(sw, ne);

      map.fitBounds(bounds, true);

      // Set maxZoom for map
      map._layersMaxZoom = _this.maxZoom;

      // Call add TileLayer
      L.TileLayer.prototype.onAdd.call(_this, map);

      // Reset tile sizes to handle non 256x256 IIIF tiles
      _this.on('tileload', function(tile, url) {

        var height = tile.tile.naturalHeight,
          width = tile.tile.naturalWidth;

        // No need to resize if tile is 256 x 256
        if (height === 256 && width === 256) return;

        tile.tile.style.width = width + 'px';
        tile.tile.style.height = height + 'px';

      });
    });
  },
  _getInfo: function() {
    var _this = this;

    // Look for a way to do this without jQuery
    $.getJSON(_this._infoUrl)
      .done(function(data) {
        _this.y = data.height;
        _this.x = data.width;

        var profile,
          tierSizes = [],
          imageSizes = [],
          scale,
          width_,
          height_,
          tilesX_,
          tilesY_;

        // Set quality based off of IIIF version
        if (data.profile instanceof Array) {
          profile = data.profile[0];
        }else {
          profile = data.profile;
        }
        switch (profile) {
          case 'http://library.stanford.edu/iiif/image-api/compliance.html#level1':
            _this.quality = 100;
            break;
          case 'http://library.stanford.edu/iiif/image-api/1.1/compliance.html':
            _this.quality = 'native';
            break;
          case 'http://library.stanford.edu/iiif/image-api/1.1/compliance.html#level1':
            _this.quality = 'native';
            break;
          case 'http://iiif.io/api/image/2/level2.json':
            _this.quality = 'default';
            break;
          case 'http://iiif.io/api/image/2/level1.json':
            _this.quality = 'default';
            break;
          case 'http://iiif.io/api/image/2/level0.json':
            _this.quality = 'default';
            break;
        }

        ceilLog2 = function(x) {
          return Math.ceil(Math.log(x) / Math.LN2);
        };

        // Calculates maxZoom for the layer
        _this.maxZoom = Math.max(ceilLog2(_this.x / _this.options.tileSize),
          ceilLog2(_this.y / _this.options.tileSize));

        for (var i = 0; i <= _this.maxZoom; i++) {
          scale = Math.pow(2, _this.maxZoom - i);
          width_ = Math.ceil(_this.x / scale);
          height_ = Math.ceil(_this.y / scale);
          tilesX_ = Math.ceil(width_ / _this.options.tileSize);
          tilesY_ = Math.ceil(height_ / _this.options.tileSize);
          tierSizes.push([tilesX_, tilesY_]);
          imageSizes.push(L.point(width_,height_));
        }

        _this._tierSizes = tierSizes;
        _this._imageSizes = imageSizes;

        // Resolved Deferred to initiate tilelayer load
        _this._infoDeferred.resolve();
      });
  },
  _infoToBaseUrl: function() {
    return this._infoUrl.replace('info.json', '');
  },
  _templateUrl: function() {
    return this._infoToBaseUrl() + '{region}/{size}/{rotation}/{quality}.{format}';
  },
  _tileShouldBeLoaded: function(coords) {
    var _this = this,
      zoom = _this._map.getZoom(),
      sizes = _this._tierSizes[zoom],
      x = coords.x,
      y = (coords.y);

    if (!sizes) return false;
    if (x < 0 || sizes[0] <= x || y < 0 || sizes[1] <= y) {
      return false;
    }else {
      return true;
    }
  },
  _getInitialZoom: function (mapSize) {
    var _this = this,
      tolerance = 0.8,
      imageSize;

    for (var i = _this.maxZoom; i >= 0; i--) {
      imageSize = this._imageSizes[i];
      if (imageSize.x * tolerance < mapSize.x && imageSize.y * tolerance < mapSize.y) {
        return i;
      }
    }
    // return a default zoom
    return 2;
  }
});

L.tileLayer.iiif = function(url, options) {
  return new L.TileLayer.Iiif(url, options);
};