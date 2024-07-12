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
}
