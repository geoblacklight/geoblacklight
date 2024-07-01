import GeoBlacklightViewerWms from "./wms.js";

class GeoBlacklightViewerTileJson extends GeoBlacklightViewerWms {
  addPreviewLayer() {
    fetch(this.data.url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Unable to fetch tile.json document");
        }
        return response.json();
      })
      .then((tileJson) => {
        const bounds = this.getBounds(tileJson),
          options = bounds ? { bounds } : {},
          url = tileJson.tiles[0],
          tileJsonLayer = L.tileLayer(url, options);
        this.overlay.addLayer(tileJsonLayer);
      })
      .catch((error) => console.debug(error));
  }

  getBounds(doc) {
    const bounds = doc.bounds;
    if (bounds) {
      const corner1 = L.latLng(bounds[1], bounds[0]),
        corner2 = L.latLng(bounds[3], bounds[2]);
      return L.latLngBounds(corner1, corner2);
    }
  }
}

export default GeoBlacklightViewerTileJson;
