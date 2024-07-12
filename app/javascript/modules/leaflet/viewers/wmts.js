import { latLng, latLngBounds, tileLayer } from "leaflet";
import LeafletViewerWms from "./wms.js";

export default class LeafletViewerWmts extends LeafletViewerWms {
  addPreviewLayer() {
    fetch(this.data.url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Unable to fetch WMTSCapabilities document");
        }
        return response.text();
      })
      .then((wmtsCapabilities) => {
        const tileInfo = this.parseCapabilities(wmtsCapabilities),
          options = tileInfo.bounds ? { bounds: tileInfo.bounds } : {},
          layer = tileLayer(tileInfo.url, options);
        this.overlay.addLayer(layer);
      })
      .catch((error) => {
        console.debug(error);
      });
  }

  parseCapabilities(wmtsCapabilities) {
    const parser = new DOMParser(),
      doc = parser.parseFromString(wmtsCapabilities, "application/xml"),
      layers = doc.getElementsByTagName("Layer"),
      selectedLayer = this.findLayer(layers),
      resourceElement = selectedLayer.getElementsByTagName("ResourceURL")[0];

    // Generate URL with Leaflet.TileLayer URL template formatting
    const tileURL = resourceElement
      .getAttribute("template")
      .replace("{Style}", this.getStyle(selectedLayer))
      .replace("{TileMatrixSet}", this.getTileMatrixSet(selectedLayer))
      .replace("TileMatrix", "z")
      .replace("TileCol", "x")
      .replace("TileRow", "y");

    return { url: tileURL, bounds: this.getBounds(selectedLayer) };
  }

  findLayer(layers) {
    if (layers.length === 1) {
      return layers[0];
    } else {
      for (let i = 0; i < layers.length; i++) {
        const ids = layers[i].getElementsByTagName("ows:Identifier");
        for (let x = 0; x < ids.length; x++) {
          if (ids[x].textContent === this.data.layerId) {
            return layers[i];
          }
        }
      }
    }
  }

  getStyle(layer) {
    const styleElement = layer.getElementsByTagName("Style")[0];
    return styleElement
      ? styleElement.getElementsByTagName("ows:Identifier")[0].textContent
      : undefined;
  }

  getTileMatrixSet(layer) {
    const tileMatrixElement = layer.getElementsByTagName("TileMatrixSet")[0];
    return tileMatrixElement ? tileMatrixElement.textContent : undefined;
  }

  getBounds(layer) {
    const lcElement = layer.getElementsByTagName("ows:LowerCorner")[0],
      ucElement = layer.getElementsByTagName("ows:UpperCorner")[0];
    if (lcElement && ucElement) {
      const lc = lcElement.textContent.split(" "),
        uc = ucElement.textContent.split(" "),
        corner1 = latLng(lc[1], lc[0]),
        corner2 = latLng(uc[1], uc[0]);
      return latLngBounds(corner1, corner2);
    }
  }
}
