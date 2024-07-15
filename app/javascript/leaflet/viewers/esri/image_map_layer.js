import { imageMapLayer } from "esri-leaflet";
import LeafletViewerEsri from "../esri.js";

export default class LeafletEsriImageMapLayer extends LeafletViewerEsri {
  getPreviewLayer() {
    // Set layer URL
    this.options.url = this.data.url;

    // Return image service layer
    return imageMapLayer(this.options);
  }
}
