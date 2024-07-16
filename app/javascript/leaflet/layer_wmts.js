import { latLng, latLngBounds } from "leaflet";

export const parseWmtsCapabilities = (wmtsCapabilities, layerId) => {
  const parser = new DOMParser(),
    doc = parser.parseFromString(wmtsCapabilities, "application/xml"),
    layers = doc.getElementsByTagName("Layer"),
    selectedLayer = findLayer(layers, layerId),
    resourceElement = selectedLayer.getElementsByTagName("ResourceURL")[0];

  // Generate URL with Leaflet.TileLayer URL template formatting
  const tileURL = resourceElement
    .getAttribute("template")
    .replace("{Style}", getStyle(selectedLayer))
    .replace("{TileMatrixSet}", getTileMatrixSet(selectedLayer))
    .replace("TileMatrix", "z")
    .replace("TileCol", "x")
    .replace("TileRow", "y");

  return { url: tileURL, bounds: getBounds(selectedLayer) };
}

const findLayer = (layers, layerId) => {
  if (layers.length === 1) {
    return layers[0];
  } else {
    for (let i = 0; i < layers.length; i++) {
      const ids = layers[i].getElementsByTagName("ows:Identifier");
      for (let x = 0; x < ids.length; x++) {
        if (ids[x].textContent === layerId) {
          return layers[i];
        }
      }
    }
  }
}

const getStyle = (layer) => {
  const styleElement = layer.getElementsByTagName("Style")[0];
  return styleElement
    ? styleElement.getElementsByTagName("ows:Identifier")[0].textContent
    : undefined;
}

const getTileMatrixSet = (layer) => {
  const tileMatrixElement = layer.getElementsByTagName("TileMatrixSet")[0];
  return tileMatrixElement ? tileMatrixElement.textContent : undefined;
}

const getBounds = (layer) => {
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
