// Adopts the Mapbox opacity control into a Leaflet plugin

!function(global) {
  'use strict';

  L.Control.LayerOpacity = L.Control.extend({
    initialize: function(layerGroup) {
      var options = {
        position: 'topleft',
        layer: layerGroup.getLayers()[0]
      };

      L.Util.setOptions(this, options);
    },

    onAdd: function(map) {
      var container = L.DomUtil.create('div', 'opacity-control'),
        handle = L.DomUtil.create('div', 'opacity-handle', container),
        bottom = L.DomUtil.create('div', 'oppacity-bottom', container);

      L.DomEvent.disableClickPropagation(container);
      this.setListeners(handle);
      return container;
    },

    setListeners: function(handle) {
      var _this = this,
        start = false,
        startTop;

      L.DomEvent.addListener(document, 'mousemove', function(e) {
        if (!start) return;
        handle.style.top = Math.max(-5, Math.min(195, startTop + parseInt(e.clientY, 10) - start)) + 'px';
        _this.options.layer.setOpacity(1 - (handle.offsetTop / 200));
      });

      L.DomEvent.addListener(handle, 'mousedown', function(e) {
        start = parseInt(e.clientY, 10);
        startTop = handle.offsetTop - 5;
        return false;
      });

      L.DomEvent.addListener(document, 'mouseup', function(e) {
        L.DomEvent.stopPropagation(e);
        start = null;
      });
    }
  });
}(this);
