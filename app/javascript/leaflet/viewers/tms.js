import GeoBlacklightViewerWms from "./wms.js";

class GeoBlacklightViewerTms extends GeoBlacklightViewerWms {
  addPreviewLayer() {
    const tmsLayer = L.tileLayer(this.data.url, { tms: true });
    this.overlay.addLayer(tmsLayer);
  }
}

export default GeoBlacklightViewerTms;
