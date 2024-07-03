import { tiledMapLayer, identifyFeatures } from "esri-leaflet";
import LeafletViewerEsri from "../esri.js";

export default class LeafletViewerEsriTiledMapLayer extends LeafletViewerEsri {
  getPreviewLayer() {
    // Set layer URL
    this.options.url = this.data.url;

    // Check if this is a tile map layer and for correct spatial reference
    if (
      this.layerInfo.singleFusedMapCache === true &&
      this.layerInfo.spatialReference.wkid === 102100
    ) {
      /**
       * TODO: allow non-mercator projections and custom scales
       *       - use Proj4Leaflet
       */

      const esriTiledMapLayer = tiledMapLayer(this.options);

      // Setup feature inspection
      this.setupInspection(esriTiledMapLayer);

      return esriTiledMapLayer;
    }
  }

  setupInspection(layer) {
    this.map.on("click", (e) => {
      this.appendLoadingMessage();

      // Query layer at click location
      identifyFeatures({
          url: layer.options.url,
          useCors: true,
        })
        .tolerance(0)
        .returnGeometry(false)
        .on(this.map)
        .at(e.latlng)
        .run((error, featureCollection) => {
          if (error) {
            this.appendErrorMessage();
          } else {
            this.populateAttributeTable(featureCollection.features[0]);
          }
        });
    });
  }

  appendLoadingMessage() {
    const loadingMessage = `<div class="spinner-border" role="status">
      <span class="sr-only">Loading...</span>
    </div>`;
    document.querySelector(".attribute-table-body").innerHTML = loadingMessage;
  }

  appendErrorMessage() {
    const errorMessage = `<tr><td colspan="2">Could not find that feature</td></tr>`;
    document.querySelector(".attribute-table-body").innerHTML = errorMessage;
  }

  populateAttributeTable(feature) {
    const properties = feature.properties;
    const tableBody = document.querySelector(".attribute-table-body");
    tableBody.innerHTML = ""; // Clear existing content

    Object.entries(properties).forEach(([key, value]) => {
      const row = `<tr><td>${key}</td><td>${value}</td></tr>`;
      tableBody.innerHTML += row;
    });
  }
}
