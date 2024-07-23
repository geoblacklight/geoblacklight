import { DomUtil, DomEvent, Control } from "leaflet";

export default class LayerOpacityControl extends Control {
  constructor(layer, options = {}) {
    super(options);
    this.options.position = "topleft";

    // Check if layer is actually a layer group
    if (typeof layer.getLayers !== "undefined") {
      // Add first layer from layer group to options
      this.options.layer = layer.getLayers()[0];
      this.options.layer = this.options.layer ? this.options.layer : layer;
    } else {
      // Add layer to options
      this.options.layer = layer;
    }
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

    DomEvent.on(document, "mousemove", (e) => {
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

    DomEvent.on(handle, "mousedown", (e) => {
      start = parseInt(e.clientY, 10);
      startTop = handle.offsetTop - 12;
      return false;
    });

    DomEvent.on(document, "mouseup", () => {
      start = null;
    });
  }
}
