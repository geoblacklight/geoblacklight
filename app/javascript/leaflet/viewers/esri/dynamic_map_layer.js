import { get, dynamicMapLayer, identifyFeatures } from "esri-leaflet";
import linkifyHtml from "linkify-html";
import LeafletViewerEsri from "../esri.js";

export default class LeafletViewerEsriDynamicMapLayer extends LeafletViewerEsri {
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

    get(this.data.url, {}, (error, response) => {
      if (!error) {
        this.layerInfo = response;

        // Get layer
        const layer = this.getPreviewLayer();

        // Add layer to map
        if (this.addPreviewLayer(layer)) {
          // Add controls if layer is added
          this.addControls();
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

    const esriDynamicMapLayer = dynamicMapLayer(this.options);

    // Setup feature inspection
    this.setupInspection(esriDynamicMapLayer);
    return esriDynamicMapLayer;
  }

  setupInspection(layer) {
    this.map.on("click", (e) => {
      this.appendLoadingMessage();

      // Query layer at click location
      const identify = identifyFeatures({
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
}
