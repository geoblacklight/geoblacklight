class LayerOpacityControl extends L.Control {
  constructor(layer, options = {}) {
    super(options);
    this.options.position = "topleft";

    // Check if layer is actually a layer group
    if (typeof layer.getLayers !== "undefined") {
      // Add first layer from layer group to options
      this.options.layer = layer.getLayers()[0];
    } else {
      // Add layer to options
      this.options.layer = layer;
    }
  }

  onAdd(map) {
    const container = L.DomUtil.create("div", "opacity-control unselectable");
    const controlArea = L.DomUtil.create("div", "opacity-area", container);
    const handle = L.DomUtil.create("div", "opacity-handle", container);
    const handleArrowUp = L.DomUtil.create("div", "opacity-arrow-up", handle);
    const handleText = L.DomUtil.create("div", "opacity-text", handle);
    const handleArrowDown = L.DomUtil.create(
      "div",
      "opacity-arrow-down",
      handle
    );
    const bottom = L.DomUtil.create("div", "opacity-bottom", container);

    L.DomEvent.stopPropagation(container);
    L.DomEvent.disableClickPropagation(container);

    this.setListeners(handle, bottom, handleText);
    handle.style.top = `${handle.offsetTop - 13 + 50}px`;
    handleText.innerHTML = `${parseInt(
      this.options.layer.options.opacity * 100
    )}%`;
    return container;
  }

  setListeners(handle, bottom, handleText) {
    let start = false;
    let startTop;

    L.DomEvent.on(document, "mousemove", (e) => {
      if (!start) return;
      const percentInverse =
        Math.max(0, Math.min(200, startTop + parseInt(e.clientY, 10) - start)) /
        2;
      handle.style.top = `${percentInverse * 2 - 13}px`;
      handleText.innerHTML = `${Math.round((1 - percentInverse / 100) * 100)}%`;
      bottom.style.height = `${Math.max(0, (100 - percentInverse) * 2 - 13)}px`;
      bottom.style.top = `${Math.min(200, percentInverse * 2 + 13)}px`;
      this.options.layer.setOpacity(1 - percentInverse / 100);
    });

    L.DomEvent.on(handle, "mousedown", (e) => {
      start = parseInt(e.clientY, 10);
      startTop = handle.offsetTop - 12;
      return false;
    });

    L.DomEvent.on(document, "mouseup", () => {
      start = null;
    });
  }
}

// Extend L.Control with LayerOpacityControl
L.Control.LayerOpacity = LayerOpacityControl;

// Factory function for consistency with Leaflet's convention
L.control.layerOpacity = function (layer, options) {
  return new L.Control.LayerOpacity(layer, options);
};
