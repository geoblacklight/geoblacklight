import { map, tileLayer } from "leaflet";
import "leaflet-iiif";
import LeafletViewerBase from "./base.js";

export default class LeafletViewerIiif extends LeafletViewerBase {
  constructor(el) {
    super(el);
    this.onLoad();
  }

  onLoad() {
    this.adjustLayout();

    this.map = map(this.element, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
    });

    this.iiifLayer = tileLayer.iiif(this.data.url).addTo(this.map);
    this.addControls();
  }

  adjustLayout() {
    // Hide attribute table
    const tableContainer = document.getElementById("table-container");
    if (tableContainer) {
      tableContainer.style.display = "none";
    }

    // Expand viewer element
    if (this.element.parentNode) {
      this.element.parentNode.className = "col-md-12";
    }
  }
}
