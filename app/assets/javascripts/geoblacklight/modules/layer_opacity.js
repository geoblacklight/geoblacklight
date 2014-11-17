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
      var container = L.DomUtil.create('div', 'opacity-control unselectable'),
        controlArea = L.DomUtil.create('div', 'opacity-area', container),
        handle = L.DomUtil.create('div', 'opacity-handle', container),
        bottom = L.DomUtil.create('div', 'opacity-bottom', container);

      L.DomEvent.disableClickPropagation(container);
      this.setListeners(handle, bottom);
      handle.style.top = handle.offsetTop - 12 + 50 + 'px';
      handle.innerHTML = parseInt(this.options.layer.options.opacity * 100) + '%';
      return container;
    },

    setListeners: function(handle, bottom) {
      var _this = this,
        start = false,
        startTop;

      L.DomEvent.addListener(document, 'mousemove', function(e) {
        if (!start) return;
        var percentInverse = Math.max(0, Math.min(200, startTop + parseInt(e.clientY, 10) - start)) / 2;
        handle.style.top = ((percentInverse * 2) - 12) + 'px';
        handle.innerHTML = Math.round((1 - (percentInverse / 100)) * 100) + '%';
        bottom.style.height = Math.max(0, (((100 - percentInverse) * 2) - 12)) + 'px';
        bottom.style.top = Math.min(200, (percentInverse * 2) + 12) + 'px';
        _this.options.layer.setOpacity(1 - (percentInverse / 100));
      });

      L.DomEvent.addListener(handle, 'mousedown', function(e) {
        L.DomEvent.disableClickPropagation(e);
        start = parseInt(e.clientY, 10);
        startTop = handle.offsetTop - 12;
        return false;
      });

      L.DomEvent.addListener(document, 'mouseup', function(e) {
        L.DomEvent.stopPropagation(e);
        L.DomEvent.disableClickPropagation(e);
        start = null;
      });
    }
  });
}(this);
