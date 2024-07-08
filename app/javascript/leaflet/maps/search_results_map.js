import { latLngBounds } from "leaflet";
import GeoBlacklightViewerMap from "../viewers/map";
import GeoSearchControl from "../controls/geosearch";
import { bboxToBounds, geoJSONToBounds } from "../utils";

export default class SearchResultsMap {
  constructor(element) {
    const data = element.dataset,
      opts = { baseUrl: data.catalogPath },
      world = latLngBounds([
        [-90, -180],
        [90, 180],
      ]);
    let bbox;

    // StaticButton
    // Create the anchor element
    const staticButtonNode = document.createElement("a");
    staticButtonNode.setAttribute("id", "gbl-static-button");
    staticButtonNode.setAttribute("href", "#");
    staticButtonNode.setAttribute("style", "display:none;");
    staticButtonNode.className = "btn btn-primary";
    staticButtonNode.textContent = "Redo search here";

    // Create the span element for the glyphicon
    const span = document.createElement("span");
    span.className = "glyphicon glyphicon-repeat";

    // Append the span to the anchor element
    staticButtonNode.appendChild(span);

    // DynamicButton
    const dynamicButtonNode = document.createElement("label");
    dynamicButtonNode.setAttribute("id", "gbl-dynamic-button");
    dynamicButtonNode.textContent = " Search when I move the map";
    dynamicButtonNode.setAttribute("style", "display:block;");

    // Create the input (checkbox) element
    const input = document.createElement("input");
    input.setAttribute("type", "checkbox");
    input.checked = true; // Set the checkbox to be checked by default

    // Insert the input element at the beginning of the label element
    dynamicButtonNode.insertBefore(input, dynamicButtonNode.firstChild);

    const initialOptions = {
      dynamic: true,
      baseUrl: "",
      searcher: function () {
        window.location.href = this.getSearchUrl();
      },
      delay: 800,
      staticButton: staticButtonNode,
      dynamicButton: dynamicButtonNode,
    };

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

    // instantiate new viewer
    this.viewer = new GeoBlacklightViewerMap(element, { bbox });

    // add geosearch control to viewer map
    this.viewer.map.addControl(new GeoSearchControl(initialOptions));

    // set hover listeners on map
    document.getElementById("content").addEventListener(
      "mouseenter",
      (event) => {
        const target = event.target.closest("[data-layer-id]");
        if (target && target.dataset.bbox !== "") {
          const geom = target.dataset.geom;
          this.viewer.addGeoJsonOverlay(JSON.parse(geom));
        }
      },
      true
    );

    document.getElementById("content").addEventListener(
      "mouseleave",
      (event) => {
        const target = event.target.closest("[data-layer-id]");
        if (target) {
          this.viewer.removeBoundsOverlay();
        }
      },
      true
    );

    window.addEventListener("popstate", () => {
      const state = history.state;
      updatePage(state ? state.url : window.location.href);
    });
  }

  updatePage(url) {
    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((response) => response.text())
      .then((html) => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");

        document
          .getElementById("documents")
          .replaceWith(doc.querySelector("#documents"));
        document
          .getElementById("sidebar")
          .replaceWith(doc.querySelector("#sidebar"));
        document
          .getElementById("sortAndPerPage")
          .replaceWith(doc.querySelector("#sortAndPerPage"));
        document
          .getElementById("appliedParams")
          .replaceWith(doc.querySelector("#appliedParams"));
        document
          .getElementById("pagination")
          .replaceWith(doc.querySelector("#pagination"));
        const mapNextElement =
          document.getElementById("map").nextElementSibling;
        if (mapNextElement) {
          mapNextElement.replaceWith(
            doc.querySelector("#map").nextElementSibling
          );
        } else {
          document
            .getElementById("map")
            .after(doc.querySelector("#map").nextElementSibling);
        }
      });
  }
}
