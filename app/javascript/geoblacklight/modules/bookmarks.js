import GeoBlacklightViewerMap from "../viewers/map.js";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-map="bookmarks"]').forEach((element) => {
    const data = element.dataset,
      world = L.latLngBounds([
        [-90, -180],
        [90, 180],
      ]);
    let geoblacklight, bbox;

    if (typeof data.mapGeom === "string") {
      bbox = L.geoJSONToBounds(JSON.parse(data.mapGeom));
    } else {
      document
        .querySelectorAll(".document [data-geom]")
        .forEach((docElement) => {
          try {
            const geomData = JSON.parse(docElement.dataset.geom);
            const currentBounds = L.geoJSONToBounds(geomData);
            if (!world.contains(currentBounds)) {
              throw new Error("Invalid bounds");
            }
            bbox =
              typeof bbox === "undefined"
                ? currentBounds
                : bbox.extend(currentBounds);
          } catch (e) {
            bbox = L.bboxToBounds("-180 -90 180 90");
          }
        });
    }

    // instantiate new map
    geoblacklight = new GeoBlacklightViewerMap(element, { bbox });
    geoblacklight.removeBoundsOverlay();

    // set hover listeners on map
    const contentElement = document.getElementById("content");
    if (contentElement) {
      contentElement.addEventListener(
        "mouseenter",
        (event) => {
          const target = event.target.closest("#documents [data-layer-id]");
          if (target && target.dataset.bbox !== "") {
            const geom = target.dataset.geom;
            geoblacklight.addGeoJsonOverlay(JSON.parse(geom));
          }
        },
        true
      ); // Use event capturing

      contentElement.addEventListener(
        "mouseleave",
        (event) => {
          const target = event.target.closest("#documents [data-layer-id]");
          if (target) {
            geoblacklight.removeBoundsOverlay();
          }
        },
        true
      ); // Use event capturing
    }
  });
});
