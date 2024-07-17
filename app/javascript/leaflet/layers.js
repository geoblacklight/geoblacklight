import { tileLayer, geoJson, circleMarker } from "leaflet";
import { dynamicMapLayer, featureLayer, tiledMapLayer } from "esri-leaflet";
import { DEFAULT_OPACITY } from "./constants";
import { parseWmtsCapabilities } from "./layer_wmts";
import { availabilityStyle, updateInformation } from "./layer_index_map";
import { getTileJsonBounds } from "./utils";

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
export const wmtsLayer = async (url, { opacity, detectRetina, layerId }) => {
  const response = await fetch(url);
  if (!response.ok)
    throw new Error("Unable to fetch WMTSCapabilities document", url);

  const wmtsCapabilities = await response.text();
  if (!wmtsCapabilities)
    throw new Error("Unable to parse WMTSCapabilities document", url);

  const tileInfo = parseWmtsCapabilities(wmtsCapabilities, layerId);
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

export const esriTiledMapLayer = async (url) => {
  const response = await fetch(url);

  if (!response.ok)
    throw new Error("Unable to fetch TiledMapLayer document", url);

  let layerInfo;
  try {
    layerInfo = await response.json();
  } catch (error) {
    throw new Error("Unable to parse TiledMapLayer document", response);
  }

  // For an example of tiledMapLayer data see nyu-test-soil-survey-map
  // We aren't sure what the json structure looks like
  // This is not rendering anything (and wasn't before we made changes) and the keys are not even present
  if (
    layerInfo.singleFusedMapCache === true &&
    layerInfo.spatialReference.wkid === 102100
  ) {
    return tiledMapLayer({ url });
  }
};

export const tileJsonLayer = async (url) => {
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error("Unable to fetch TiledJson document", url);
  }

  const layerInfo = await response.json();

  const bounds = getTileJsonBounds(layerInfo);
  const options = bounds ? { bounds } : {};
  const tileUrl = layerInfo.tiles[0];
  return tileLayer(tileUrl, options);
};

export const indexMapLayer = async (url, leafletOptions) => {
  let prevLayer = null;

  const response = await fetch(url);

  if (!response.ok) {
    throw new Error("Unable to fetch indexMapLayer document", url);
  }

  const data = await response.json();

  const geoJSONLayer = geoJson(data, {
    style: (feature) =>
      availabilityStyle(feature.properties.available, leafletOptions),
    onEachFeature: (feature, layer) => {
      if (feature.properties.label !== null) {
        layer.bindTooltip(feature.properties.label);
      }
      if (feature.properties.available !== null) {
        layer.on("click", (e) => {
          layer.setStyle(leafletOptions.LAYERS.INDEX.SELECTED);
          if (prevLayer !== null) {
            geoJSONLayer.resetStyle(prevLayer);
          }
          prevLayer = layer;
          updateInformation(feature.properties);
        });
      }
    },
    pointToLayer: (feature, latlng) => circleMarker(latlng),
  });

  return geoJSONLayer;
};
