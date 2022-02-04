//= require geoblacklight/viewers/wms

GeoBlacklight.Viewer.Wmts = GeoBlacklight.Viewer.Wms.extend({

  addPreviewLayer: function() {
    var _this = this;
    fetch(this.data.url).then(function(response) {
      if (!response.ok) {
          throw new Error("Unable to fetch WMTSCapabilities document");
      }
      return response.text();
    }).then(function(wmtsCapabilities) {
      var tileInfo = _this.parseCapabilities(wmtsCapabilities),
          options = tileInfo.bounds ? { bounds: tileInfo.bounds } : {},
          tileLayer = L.tileLayer(tileInfo.url, options);
      _this.overlay.addLayer(tileLayer);
    }).catch(function(error) {
      console.debug(error);
    });
  },

  parseCapabilities: function(wmtsCapabilities) {
    var parser = new DOMParser(),
        doc = parser.parseFromString(wmtsCapabilities, "application/xml"),
        layers = doc.getElementsByTagName("Layer"),
        selectedLayer = this.findLayer(layers),
        resourceElement = selectedLayer.getElementsByTagName("ResourceURL")[0];

    // Generate URL with Leaflet.TileLayer URL template formatting
    var tileURL = resourceElement.getAttribute("template")
      .replace("{Style}", this.getStyle(selectedLayer))
      .replace("{TileMatrixSet}", this.getTileMatrixSet(selectedLayer))
      .replace("TileMatrix", "z")
      .replace("TileCol","x")
      .replace("TileRow","y");

    return { url: tileURL, bounds: this.getBounds(selectedLayer) };
  },

  findLayer: function(layers) {
    if (layers.length === 1) {
      // If there is only one layer in the document, return it
      return layers[0];
    } else {
      // Search each layer for an identifier that matches the
      // layerId and return it
      for (i = 0; i < layers.length; i++) {
        var ids = layers[i].getElementsByTagName("ows:Identifier");
        for(x = 0; x < ids.length; x++) {
          if (ids[x].textContent === this.data.layerId) {
            return layers[i];
          }
        }
      }
    }
  },

  getStyle: function(layer) {
    var styleElement = layer.getElementsByTagName("Style")[0];
    if(styleElement) {
      return styleElement.getElementsByTagName("ows:Identifier")[0].textContent;
    }
  },

  getTileMatrixSet: function(layer) {
    var tileMatrixElement = layer.getElementsByTagName("TileMatrixSet")[0];
    if(tileMatrixElement) {
      return tileMatrixElement.textContent;
    }
  },

  getBounds: function(layer) {
    // Get the layer's lower corner and upper corner values,
    // if they exist, and convert to a Leaflet latlngBounds object
    var lcElement = layer.getElementsByTagName("ows:LowerCorner")[0],
        ucElement = layer.getElementsByTagName("ows:UpperCorner")[0];
    if(lcElement && ucElement) {
      var lc = lcElement.textContent.split(" "),
          uc = ucElement.textContent.split(" "),
          corner1 = L.latLng(lc[1], lc[0]),
          corner2 = L.latLng(uc[1], uc[0]);
      return L.latLngBounds(corner1, corner2);
    }
  }
});
