import { Controller } from "@hotwired/stimulus";
import { geoJSONToBounds } from "../leaflet/utils";
import { DEFAULT_BOUNDS } from "../leaflet/constants";

export default class SearchResultsController extends Controller {
  static targets = ["result"];
  static outlets = ["leaflet-viewer"];

  // Fit the map to the combined bounding box of all search results
  // If a bounding box query is already active, do not override it
  fitResultBounds() {
    if (new URL(window.location).searchParams.get("bbox")) return;
    this.leafletViewerOutlet.fitBounds(this.getMaximalBounds());
  }

  // Get the bounding box of a search result from its data attributes
  getResultBounds(resultElement) {
    const geomElement = resultElement.querySelector("[data-geom]");
    if (geomElement && geomElement.dataset.geom) {
      return geoJSONToBounds(JSON.parse(geomElement.dataset.geom));
    }
  }

  // Find the combined bounding box of all search results
  getMaximalBounds() {
    const bounds = this.resultTargets.map(this.getResultBounds);
    const nonNullBounds = bounds.filter((b) => b);

    if (nonNullBounds.length > 0) {
      return nonNullBounds.reduce((max, b) => max.extend(b));
    }

    return DEFAULT_BOUNDS;
  }

  // Preview the selected search result's bounding box on the map
  previewResultOnMap(event) {
    const geomElement = event.target.querySelector("[data-geom]");
    if (geomElement && geomElement.dataset.geom !== "") {
      const geom = JSON.parse(geomElement.dataset.geom);
      const bbox = geoJSONToBounds(geom);
      this.leafletViewerOutlet.addBoundsOverlay(bbox);
    }
  }

  // Remove the previewed bounding box
  clearPreview() {
    this.leafletViewerOutlet.removeBoundsOverlay();
  }
}
