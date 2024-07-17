import { Controller } from "@hotwired/stimulus";
import GeoSearchControl from "../leaflet/controls/geosearch.js";
import { geoJSONToBounds } from "../leaflet/utils";
import { DEFAULT_BOUNDS } from "../leaflet/constants";

const geosearchDefaultOptions = {
  dynamic: true,
  delay: 800,
};

export default class SearchResultsController extends Controller {
  static values = {
    catalogUrl: String,
  };

  static targets = ["result"];
  static outlets = ["leaflet-viewer"];

  addGeosearch() {
    this.leafletViewerOutlet.fitBounds(this.getMaximalBounds());

    // FIXME: if we add the geosearch control too quickly, even after calling
    // fitBounds(), leaflet registers the call to fitBounds() as having moved
    // the map, which activates the geo search. This triggers an infinite
    // loop. Using a timeout is kind of a hacky solution.
    setTimeout(() => {
      const control = new GeoSearchControl({
        baseUrl: this.catalogUrlValue,
        ...geosearchDefaultOptions,
      });
      this.leafletViewerOutlet.addControl(control);
      this.leafletViewerOutlet.map.geosearch.enable();
    }, 500)
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
