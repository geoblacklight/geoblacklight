import GeoBlacklightViewerEsri from "../esri.js";

class GeoBlacklightViewerEsriFeatureLayer extends GeoBlacklightViewerEsri {
  constructor(options) {
    super(options);
    this.defaultStyles = {
      esriGeometryPoint: "",
      esriGeometryMultipoint: "",
      esriGeometryPolyline: { color: "blue", weight: 3 },
      esriGeometryPolygon: { color: "blue", weight: 2 },
    };
  }

  getPreviewLayer() {
    // Set layer URL
    this.options.url = this.data.url;

    // Set default style
    this.options.style = this.getFeatureStyle();

    // Define feature layer
    this.esriFeatureLayer = L.esri.featureLayer(this.options);

    // Setup feature inspection and opacity
    this.setupInspection(this.esriFeatureLayer);
    this.setupInitialOpacity(this.esriFeatureLayer);

    return this.esriFeatureLayer;
  }

  controlPreload() {
    // Define setOpacity function that works for SVG elements
    this.esriFeatureLayer.setOpacity = (opacity) => {
      document.querySelectorAll(".leaflet-clickable").forEach((element) => {
        element.style.opacity = opacity;
      });
    };
  }

  getFeatureStyle() {
    // Lookup style hash based on layer geometry type and return function
    return (feature) => this.defaultStyles[this.layerInfo.geometryType];
  }

  setupInitialOpacity(featureLayer) {
    featureLayer.on("load", () => {
      featureLayer.setOpacity(this.options.opacity || 1); // Assuming `this.options.opacity` is defined
    });
  }

  setupInspection(featureLayer) {
    // Inspect on click
    featureLayer.on("click", (e) => {
      const distance = 3000 / (1 + this.map.getZoom());

      this.appendLoadingMessage();

      // Query layer at click location
      featureLayer
        .query()
        .returnGeometry(false)
        .nearby(e.latlng, distance)
        .run((error, featureCollection) => {
          if (error || !featureCollection.features.length) {
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
      <div class="spinner-border" role="status"><span class="sr-only">Inspecting</span></div>
      </td></tr>`;
    const tableBody = document.querySelector(".attribute-table-body");
    if (tableBody) {
      tableBody.parentNode.replaceChild(spinner, tableBody);
    }
  }

  appendErrorMessage() {
    const errorMessage = `<tbody class="attribute-table-body">
      <tr><td colspan="2">Could not find that feature</td></tr></tbody>`;
    const tableBody = document.querySelector(".attribute-table-body");
    if (tableBody) {
      tableBody.innerHTML = errorMessage;
    }
  }

  populateAttributeTable(feature) {
    let htmlContent = `<tbody class="attribute-table-body">`;
    Object.entries(feature.properties).forEach(([key, value]) => {
      htmlContent += `<tr><td>${key}</td><td>${value}</td></tr>`;
    });
    htmlContent += `</tbody>`;
    const tableBody = document.querySelector(".attribute-table-body");
    if (tableBody) {
      tableBody.innerHTML = htmlContent;
    }
  }
}

export default GeoBlacklightViewerEsriFeatureLayer;
