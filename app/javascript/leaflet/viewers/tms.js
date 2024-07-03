import { tileLayer } from "leaflet";
import LeafletViewerWms from "./wms.js";

export default class LeafletViewerTms extends LeafletViewerWms {
  addPreviewLayer() {
    const tmsLayer = tileLayer(this.data.url, { tms: true });
    this.overlay.addLayer(tmsLayer);
  }
}
