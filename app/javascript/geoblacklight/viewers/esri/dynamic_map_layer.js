import GeoBlacklightViewerEsri from "../esri.js";
import linkifyHtml from "linkify-html";

class GeoBlacklightViewerEsriDynamicMapLayer extends GeoBlacklightViewerEsri {
  // Override to parse between dynamic layer types
  getEsriLayer() {
    // Remove any trailing slash from endpoint url
    this.data.url = this.data.url.replace(/\/$/, "");

    // Get last segment from url
    const pathArray = this.data.url.split("/");
    const lastSegment = pathArray[pathArray.length - 1];

    // If the last segment is an integer, slice and save as dynamicLayerId
    if (Number(lastSegment) === parseInt(lastSegment, 10)) {
      this.dynamicLayerId = lastSegment;
      this.data.url = this.data.url.slice(0, -(lastSegment.length + 1));
    }

    L.esri.get(this.data.url, {}, (error, response) => {
      if (!error) {
        this.layerInfo = response;

        // Get layer
        const layer = this.getPreviewLayer();

        // Add layer to map
        if (this.addPreviewLayer(layer)) {
          // Add controls if layer is added
          this.loadControls();
        }
      }
    });
  }

  getPreviewLayer() {
    // Set layer url
    this.options.url = this.data.url;

    // Show only single layer, if specified
    if (this.dynamicLayerId) {
      this.options.layers = [this.dynamicLayerId];
    }

    const esriDynamicMapLayer = L.esri.dynamicMapLayer(this.options);

    // Setup feature inspection
    this.setupInspection(esriDynamicMapLayer);
    return esriDynamicMapLayer;
  }

  setupInspection(layer) {
    this.map.on("click", (e) => {
      this.appendLoadingMessage();

      // Query layer at click location
      const identify = L.esri
        .identifyFeatures({
          url: layer.options.url,
          useCors: true,
        })
        .tolerance(2)
        .returnGeometry(false)
        .on(this.map)
        .at(e.latlng);

      // Query specific layer if dynamicLayerId is set
      if (this.dynamicLayerId) {
        identify.layers("all: " + this.dynamicLayerId);
      }

      identify.run((error, featureCollection, response) => {
        if (error || response.results < 1) {
          this.appendErrorMessage();
        } else {
          this.populateAttributeTable(featureCollection.features[0]);
        }
      });
    });
  }

  appendLoadingMessage() {
    const spinner = document.createElement("tbody");
    spinner.className = "attribute-table-body";
    spinner.innerHTML = `<tr><td colspan="2">
      <span id="attribute-table">
      <div class="spinner-border" role="status"><span class="sr-only">Inspecting</span></div>
      </span>
      </td></tr>`;
    document.querySelector(".attribute-table-body").replaceWith(spinner);
  }

  appendErrorMessage() {
    const errorMessage = document.createElement("tbody");
    errorMessage.className = "attribute-table-body";
    errorMessage.innerHTML = `<tr><td colspan="2">Could not find that feature</td></tr>`;
    document.querySelector(".attribute-table-body").replaceWith(errorMessage);
  }

  populateAttributeTable(feature) {
    const html = document.createElement("tbody");
    html.className = "attribute-table-body";
    Object.entries(feature.properties).forEach(([property, value]) => {
      const row = document.createElement("tr");
      row.innerHTML = `<td>${property}</td><td>${linkifyHtml(value)}</td>`;
      html.appendChild(row);
    });
    document.querySelector(".attribute-table-body").replaceWith(html);
  }
}

export default GeoBlacklightViewerEsriDynamicMapLayer;
