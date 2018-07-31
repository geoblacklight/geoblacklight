// Adopts the Mapbox opacity control into a Leaflet plugin

!function(global) {
  'use strict';

  L.Control.LayerOpacity = L.Control.extend({
    initialize: function(layer) {
      var options = { position: 'topleft' };

      // check if layer is actually a layer group
      if (typeof layer.getLayers !== 'undefined') {

        // add first layer from layer group to options
        options.layer = layer.getLayers()[0];
      } else {

        // add layer to options
        options.layer = layer;
      }

      L.Util.setOptions(this, options);
    },

    onAdd: function(map) {
      var container = L.DomUtil.create('div', 'opacity-control unselectable'),
        controlArea = L.DomUtil.create('div', 'opacity-area', container),
        handle = L.DomUtil.create('div', 'opacity-handle', container),
        handleArrowUp = L.DomUtil.create('div', 'opacity-arrow-up', handle),
        handleText = L.DomUtil.create('div', 'opacity-text', handle),
        handleArrowDown = L.DomUtil.create('div', 'opacity-arrow-down', handle),
        bottom = L.DomUtil.create('div', 'opacity-bottom', container);

      L.DomEvent.stopPropagation(container);
      L.DomEvent.disableClickPropagation(container);

      this.setListeners(handle, bottom, handleText);
      handle.style.top = handle.offsetTop - 13 + 50 + 'px';
      handleText.innerHTML = parseInt(this.options.layer.options.opacity * 100) + '%';
      return container;
    },

    setListeners: function(handle, bottom, handleText) {
      var _this = this,
        start = false,
        startTop;

      L.DomEvent.on(document, 'mousemove', function(e) {
        if (!start) return;
        var percentInverse = Math.max(0, Math.min(200, startTop + parseInt(e.clientY, 10) - start)) / 2;
        handle.style.top = ((percentInverse * 2) - 13) + 'px';
        handleText.innerHTML = Math.round((1 - (percentInverse / 100)) * 100) + '%';
        bottom.style.height = Math.max(0, (((100 - percentInverse) * 2) - 13)) + 'px';
        bottom.style.top = Math.min(200, (percentInverse * 2) + 13) + 'px';
        _this.options.layer.setOpacity(1 - (percentInverse / 100));
      });

      L.DomEvent.on(handle, 'mousedown', function(e) {
        start = parseInt(e.clientY, 10);
        startTop = handle.offsetTop - 12;
        return false;
      });

      L.DomEvent.on(document, 'mouseup', function(e) {
        start = null;
      });
    }
  });
}(this);
