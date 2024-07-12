import { tileLayer } from "leaflet";
import LeafletViewerWms from "./wms.js";

export default class LeafletViewerXyz extends LeafletViewerWms {
  addPreviewLayer() {
    const xyzLayer = tileLayer(this.data.url);
    this.overlay.addLayer(xyzLayer);
  }
}
