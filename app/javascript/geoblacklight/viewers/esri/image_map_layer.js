import GeoBlacklightViewerEsri from "../esri.js";

class GeoBlacklightViewerEsriImageMapLayer extends GeoBlacklightViewerEsri {
  constructor(options) {
    super(options);
    this.layerInfo = {};
  }

  getPreviewLayer() {
    // Set layer URL
    this.options.url = this.data.url;

    // Return image service layer
    return L.esri.imageMapLayer(this.options);
  }
}

export default GeoBlacklightViewerEsriImageMapLayer;
