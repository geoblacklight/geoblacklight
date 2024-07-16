import { tiledMapLayer, identifyFeatures } from "esri-leaflet";
import LeafletViewerEsri from "../esri.js";

export default class LeafletViewerEsriTiledMapLayer extends LeafletViewerEsri {
  // TODO: This method needs to be ported over to a new inspection.js file
  // can delete this file when done.
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
