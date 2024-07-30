import { latLngBounds} from "leaflet";
import GeoBlacklightViewerMap from "../viewers/map";
import { bboxToBounds, geoJSONToBounds } from "../utils";

// Set up the leaflet map on the bookmarks page
export default class BookmarksMap {
  constructor(element) {
    const data = element.dataset,
      world = latLngBounds([
        [-90, -180],
        [90, 180],
      ]);
    let bbox;

    if (typeof data.mapGeom === "string") {
      bbox = geoJSONToBounds(JSON.parse(data.mapGeom));
    } else {
      document
        .querySelectorAll(".document [data-geom]")
        .forEach((docElement) => {
          try {
            const geomData = JSON.parse(docElement.dataset.geom);
            const currentBounds = geoJSONToBounds(geomData);
            if (!world.contains(currentBounds)) {
              throw new Error("Invalid bounds");
            }
            bbox =
              typeof bbox === "undefined"
                ? currentBounds
                : bbox.extend(currentBounds);
          } catch (e) {
            bbox = bboxToBounds("-180 -90 180 90");
          }
        });
    }

    // instantiate new map
    const viewer = new GeoBlacklightViewerMap(element, { bbox });
    viewer.removeBoundsOverlay();

    // set hover listeners on map
    const contentElement = document.getElementById("content");
    if (contentElement) {
      contentElement.addEventListener(
        "mouseenter",
        (event) => {
          const target = event.target.closest("#documents [data-layer-id]");
          if (target && target.dataset.bbox !== "") {
            const geom = target.dataset.geom;
            viewer.addGeoJsonOverlay(JSON.parse(geom));
          }
        },
        true
      ); // Use event capturing

      contentElement.addEventListener(
        "mouseleave",
        (event) => {
          const target = event.target.closest("#documents [data-layer-id]");
          if (target) {
            viewer.removeBoundsOverlay();
          }
        },
        true
      ); // Use event capturing
    }
  }
}
