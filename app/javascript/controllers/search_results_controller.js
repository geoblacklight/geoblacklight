import { Controller } from "@hotwired/stimulus";
import { geoJSONToBounds } from "../leaflet/utils";

export default class SearchResultsController extends Controller {
  static outlets = ["leaflet-viewer"];

  previewResultOnMap(event) {
    const geomElement = event.target.querySelector("[data-geom]");
    if (geomElement && geomElement.dataset.geom !== "") {
      const geom = JSON.parse(geomElement.dataset.geom);
      const bbox = geoJSONToBounds(geom);
      this.leafletViewerOutlet.addBoundsOverlay(bbox);
    }
  }

  clearPreview() {
    this.leafletViewerOutlet.removeBoundsOverlay();
  }
}
