import { DomUtil, DomEvent, Control } from "leaflet";
import { getLayerOpacity } from "geoblacklight/leaflet/utils";

export default class LayerOpacityControl extends Control {
  constructor(layer, options = {}) {
    super(options);
    this.options.position = "topleft";
    var layers = [layer]
    // Check if layer is actually a layer group
    if (typeof layer.getLayers !== "undefined") {
      layers = layer.getLayers();
      layers = layers && layers[0] instanceof L.Layer ? layers : [layer];
    } else {
      this.layersOnLoad = Object.keys(layer).includes('_layers');
    }
    this.options.layer = layers[0];
    this.options.layers = this.layersOnLoad ? [] : layers;
  }

  onAdd(map) {
    const container = DomUtil.create("div", "opacity-control unselectable");
    const controlArea = DomUtil.create("div", "opacity-area", container);
    const handle = DomUtil.create("div", "opacity-handle", container);
    const handleArrowUp = DomUtil.create("div", "opacity-arrow-up", handle);
    const handleText = DomUtil.create("div", "opacity-text", handle);
    const handleArrowDown = DomUtil.create("div", "opacity-arrow-down", handle);
    const bottom = DomUtil.create("div", "opacity-bottom", container);

    DomEvent.stopPropagation(container);
    DomEvent.disableClickPropagation(container);
    this.setListeners(handle, bottom, handleText, map);

    handle.setAttribute("tabindex", "0");
    let opacity =  getLayerOpacity(this.options.layer);
    const opacityPercentage = parseInt(opacity * 100);
    handle.style.zIndex = 4;
    handle.style.top = `calc(100% - ${opacityPercentage}% - 12px)`;
    handleText.innerHTML = `${opacityPercentage}%`;
    return container;
  }

  updateMapOpacity(opacity) {
    this.options.layers.forEach((layer) => this.layerOpacity(layer, opacity))
  }

  layerOpacity(layer, opacity) {
    try {
      layer.setStyle({"fillOpacity": opacity, "opacity": opacity})
    } catch {
      try {
        layer.setOpacity(opacity);
      } catch {
        console.error("Couldn't set opacity for layer", layer)
      }
    }
  }

  setListeners(handle, bottom, handleText, map) {
    let start = false;
    let startTop;

    DomEvent.on(document, "mousemove", (e) => {
      if (!start) return;
      const percentInverse =
        Math.max(0, Math.min(200, startTop + parseInt(e.clientY, 10) - start)) /
        2;
      handle.style.top = `${percentInverse * 2 - 13}px`;
      handleText.innerHTML = `${Math.round((1 - percentInverse / 100) * 100)}%`;
      bottom.style.height = `${Math.max(0, (100 - percentInverse) * 2 - 13)}px`;
      bottom.style.top = `${Math.min(200, percentInverse * 2 + 13)}px`;
      this.updateMapOpacity(1 - percentInverse / 100);
    });

    DomEvent.on(handle, "mousedown", (e) => {
      start = parseInt(e.clientY, 10);
      startTop = handle.offsetTop - 12;
      return false;
    });

    DomEvent.on(document, "mouseup", () => {
      start = null;
    });

    let _this = this;
    DomEvent.on(map, 'layeradd', function(e) {
      if (e.layer.options.addToOpacitySlider || (_this.layersOnLoad && e.layer instanceof L.Layer)){
        _this.options.layers.push(e.layer);
      }
    });

    DomEvent.on(map, 'layerremove', function(e) {
      if (e.layer.options.addToOpacitySlider){
        const index = _this.options.layers.indexOf(e.layer);
        if (index) { _this.options.layers.splice(index, 1)};
      }
    });


    DomEvent.on(handle, 'keydown', function(e) {
      const opacity = _this.geoJSON ? _this.options.layer.style.fillOpacity : _this.options.layer.options.opacity;
      const step = 1;
      var newOpacity;
      if (e.key == 'ArrowDown'){
        newOpacity = opacity * 100 - step;
      } else if (e.key == 'ArrowUp') {
        newOpacity = opacity * 100 + step;
      } else {
        return;
      }
      e.preventDefault();
      if (newOpacity > 100 || newOpacity < 0) { return; }
      newOpacity = Math.round(newOpacity)
      handle.style.top = `calc(100% - ${newOpacity}% - 12px)`;
      handleText.innerHTML = newOpacity + "%";
      bottom.style.height = newOpacity + "%";
      bottom.style.top = `calc(100% - ${newOpacity}%)`;
      _this.updateMapOpacity(newOpacity / 100)
    });
  }
}
