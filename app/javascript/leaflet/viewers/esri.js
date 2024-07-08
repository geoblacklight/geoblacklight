import { get as esriGet } from "esri-leaflet";
import linkifyHtml from "linkify-html";
import { geoJSONToBounds } from "../utils.js";
import LeafletViewerMap from "./map.js";

export default class LeafletViewerEsri extends LeafletViewerMap {
  constructor(element, options) {
    super(element, options);
    this.layerInfo = {};
  }

  onLoad() {
    super.onLoad();
    this.options.bbox = geoJSONToBounds(JSON.parse(this.data.mapGeom));
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.available) {
      this.getEsriLayer();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  }

  getEsriLayer() {
    // Remove any trailing slash from endpoint url
    this.data.url = this.data.url.replace(/\/$/, "");

    esriGet(this.data.url, {}, (error, response) => {
      if (!error) {
        this.layerInfo = response;

        // Get layer as defined in submodules (e.g., esri/mapservice)
        const layer = this.getPreviewLayer();

        // Add layer to map
        if (this.addPreviewLayer(layer)) {
          // Add controls if layer is added
          this.addControls();
        }
      }
    });
  }

  addPreviewLayer(layer) {
    // If not null, add layer to map
    if (layer) {
      this.overlay.addLayer(layer);
      return true;
    }
    return false;
  }

  appendLoadingMessage() {
    const spinner = `<tbody class="attribute-table-body"><tr><td colspan="2">
      <span id="attribute-table">
      <div class="spinner-border" role="status"><span class="sr-only">Inspecting</span></div>
      </span>
      </td></tr></tbody>`;

    document.querySelector(".attribute-table-body").innerHTML = spinner;
  }

  appendErrorMessage() {
    document.querySelector(
      ".attribute-table-body"
    ).innerHTML = `<tbody class="attribute-table-body">
      <tr><td colspan="2">Could not find that feature</td></tr></tbody>`;
  }

  populateAttributeTable(feature) {
    let html = '<tbody class="attribute-table-body">';

    // Step through properties and append to table
    Object.keys(feature.properties).forEach((property) => {
      html += `<tr><td>${property}</td>
               <td>${linkifyHtml(feature.properties[property])}</td></tr>`;
    });
    html += "</tbody>";

    const tableBody = document.querySelector(".attribute-table-body");
    if (tableBody) {
      tableBody.outerHTML = html; // Replace existing table body with new content
    }
  }
}
