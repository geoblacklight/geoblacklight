import GeoBlacklightViewerWms from "./wms.js";

class GeoBlacklightViewerXyz extends GeoBlacklightViewerWms {
  addPreviewLayer() {
    const xyzLayer = L.tileLayer(this.data.url);
    this.overlay.addLayer(xyzLayer);
  }
}

export default GeoBlacklightViewerXyz;
