import { tileLayer } from "leaflet";
import { dynamicMapLayer, featureLayer } from "esri-leaflet";
import { DEFAULT_OPACITY } from "./constants";

// Create a WMS tile layer
export const wmsLayer = (url, { layerId, opacity, detectRetina }) => {
  return tileLayer.wms(url, {
    layers: layerId,
    format: "image/png",
    transparent: true,
    tiled: true,
    CRS: "EPSG:3857",
    opacity: opacity || DEFAULT_OPACITY,
    detectRetina: detectRetina || false,
  });
};

// Fetch a WMTSCapabilities document and create a tile layer using it
export const wmtsLayer = async (url, { opacity, detectRetina }) => {
  const response = await fetch(url);
  if (!response.ok)
    throw new Error("Unable to fetch WMTSCapabilities document", url);

  const wmtsCapabilities = await response.text();
  if (!wmtsCapabilities)
    throw new Error("Unable to parse WMTSCapabilities document", url);

  const tileInfo = parseWmtsCapabilities(wmtsCapabilities);
  const options = tileInfo.bounds ? { bounds: tileInfo.bounds } : {};
  return tileLayer(tileInfo.url, {
    opacity: opacity || DEFAULT_OPACITY,
    detectRetina: detectRetina || false,
    ...options,
  });
};

// Create an ESRI dynamic map layer
export const esriDynamicMapLayer = (url, { opacity, detectRetina }) => {
  // Remove any trailing slash and get the last segment from the URL
  url = url.replace(/\/$/, "");
  const pathArray = url.split("/");
  const lastSegment = pathArray[pathArray.length - 1];

  // If the last segment is an integer it's the layer ID
  let layerId;
  if (Number(lastSegment) === parseInt(lastSegment, 10)) {
    layerId = lastSegment;
    url = url.slice(0, -(lastSegment.length + 1));
  }

  const options = layerId ? { layers: [layerId] } : {};
  return dynamicMapLayer({
    url,
    opacity: opacity || DEFAULT_OPACITY,
    detectRetina: detectRetina || false,
    ...options,
  });
};

export const esriFeatureLayer = (url, { opacity, detectRetina }) => {
  return featureLayer({
    url,
    opacity: opacity || DEFAULT_OPACITY,
    detectRetina: detectRetina || false,
  });
};
