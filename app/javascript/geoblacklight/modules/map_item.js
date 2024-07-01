import GeoBlacklightViewerMap from "../viewers/map.js";
import GeoBlacklightViewerCog from "../viewers/cog.js";
import GeoBlacklightViewerEsri from "../viewers/esri.js";
import GeoBlacklightViewerEsriDynamicMapLayer from "../viewers/esri/dynamic_map_layer.js";
import GeoBlacklightViewerEsriFeatureLayer from "../viewers/esri/feature_layer.js";
import GeoBlacklightViewerEsriImageMapLayer from "../viewers/esri/image_map_layer.js";
import GeoBlacklightViewerEsriTiledMapLayer from "../viewers/esri/tiled_map_layer.js";
import GeoBlacklightViewerIiif from "../viewers/iiif.js";
import GeoBlacklightViewerIndexMap from "../viewers/index_map.js";
import GeoBlacklightViewerOembed from "../viewers/oembed.js";
import GeoBlacklightViewerPmtiles from "../viewers/pmtiles.js";
import GeoBlacklightViewerTileJson from "../viewers/tilejson.js";
import GeoBlacklightViewerTms from "../viewers/tms.js";
import GeoBlacklightViewerWms from "../viewers/wms.js";
import GeoBlacklightViewerWmts from "../viewers/wmts.js";
import GeoBlacklightViewerXyz from "../viewers/xyz.js";

const dict = new Map([
  ["Map", GeoBlacklightViewerMap],
  ["Cog", GeoBlacklightViewerCog],
  ["Esri", GeoBlacklightViewerEsri],
  ["DynamicMapLayer", GeoBlacklightViewerEsriDynamicMapLayer],
  ["FeatureLayer", GeoBlacklightViewerEsriFeatureLayer],
  ["ImageMapLayer", GeoBlacklightViewerEsriImageMapLayer],
  ["TiledMapLayer", GeoBlacklightViewerEsriTiledMapLayer],
  ["Iiif", GeoBlacklightViewerIiif],
  ["IndexMap", GeoBlacklightViewerIndexMap],
  ["Oembed", GeoBlacklightViewerOembed],
  ["Pmtiles", GeoBlacklightViewerPmtiles],
  ["Tilejson", GeoBlacklightViewerTileJson],
  ["Tms", GeoBlacklightViewerTms],
  ["Wms", GeoBlacklightViewerWms],
  ["Wmts", GeoBlacklightViewerWmts],
  ["Xyz", GeoBlacklightViewerXyz],
]);

document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll('[data-map="item"]').forEach((element, i) => {
    // get viewer module from protocol value and capitalize to match class name
    let viewerName = element.getAttribute("data-protocol"),
      viewer;

    console.log(viewerName);

    // get new viewer instance and pass in element
    viewer = new (dict.get(viewerName))(element);
    viewer.load();
  });

  document.querySelectorAll(".truncate-abstract").forEach((element, i) => {
    let lines = 12 * parseFloat(window.getComputedStyle(element).fontSize);
    if (element.getBoundingClientRect().height < lines) return;
    let id = element.id || "truncate-" + i;

    element.id = id;
    element.classList.add("collapse");

    let control = document.createElement("button");
    control.className = "btn btn-link p-0 border-0";
    control.setAttribute("data-toggle", "collapse");
    control.setAttribute("aria-expanded", "false");
    control.setAttribute("data-target", `#${id}`);
    control.setAttribute("aria-controls", id);
    control.textContent = "Read more";

    control.addEventListener("click", function () {
      let isExpanded = control.getAttribute("aria-expanded") === "true";
      control.textContent = isExpanded ? "Read more" : "Close";
      control.setAttribute("aria-expanded", !isExpanded);
      element.classList.toggle("show");
    });

    element.parentNode.insertBefore(control, element.nextSibling);
  });
});
