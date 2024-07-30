/** This file contains methods for creating the various types of leaflet and esri-leaflet layers required in leaflet_viewer_controller.
 * If complex logic is needed for a certain layer type, it is broken out into its own file,
 * such as layer_wmts.js for WMTS layers and layer_index_map.js for index map layers, at the same directory level as this file.
 */
import { tileLayer, geoJson, circleMarker } from "leaflet";
import { dynamicMapLayer, featureLayer, tiledMapLayer } from "esri-leaflet";
import { DEFAULT_OPACITY } from "./constants";
import { parseWmtsCapabilities } from "./layer_wmts";
import { availabilityStyle, updateInformation } from "./layer_index_map";
import { getTileJsonBounds } from "./utils";

// Create a leaflet tile layer for WMS
export const wmsLayer = (url, { layerId, opacity, detectRetina }) => {
  return tileLayer.wms(url, {
    layers: layerId,
    format: "image/png",
    transparent: true,
    tiled: true,
    CRS: "EPSG:3857",
    opacity,
    detectRetina,
  });
};

// Fetch a WMTSCapabilities document and create a leaflet tileLayer using it
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
    opacity,
    detectRetina,
    ...options,
  });
};

// Create an ESRI-leaflet dynamic map layer
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
    opacity,
    detectRetina,
    ...options,
  });
};

// Create an ESRI-leaflet feature layer
export const esriFeatureLayer = (url, { opacity, detectRetina }) => {
  return featureLayer({
    url,
    opacity,
    detectRetina,
  });
};

// Create an ESRI tiled map layer
export const esriTiledMapLayer = async (url, options) => {
  const response = await fetch(url);

  if (!response.ok)
    throw new Error("Unable to fetch EsriTiledMapLayer document", url);

  let layerInfo;
  try {
    layerInfo = await response.json();
  } catch (error) {
    throw new Error("Unable to parse TiledMapLayer document", response);
  }

  // For an example of tiledMapLayer data see nyu-test-soil-survey-map
  // We aren't sure what the json structure looks like
  // This is not rendering anything (and wasn't before we made changes) and the keys are not even present
  // Check out this json: https://dnrmaps.wi.gov/arcgis2/rest/services/TS_AGOL_STAGING_SERVICES/EN_AGOL_STAGING_SurfaceWater_WTM/MapServer/2?f=pjson -- wrong protocol, now a feature map?? 
  if (
    layerInfo.singleFusedMapCache === true &&
    layerInfo.spatialReference.wkid === 102100
  ) {
    return tiledMapLayer({ url, ...options });
  }
};

// Create a leaflet tile layer 
export const tileJsonLayer = async (url, options) => {
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error("Unable to fetch TiledJson document", url);
  }

  const layerInfo = await response.json();

  const bounds = getTileJsonBounds(layerInfo);
  if (bounds) options.bounds = bounds;
  const tileUrl = layerInfo.tiles[0];
  return tileLayer(tileUrl, options);
};

// Fetch an indexMapLayer document and create a leaflet geoJSON layer
export const indexMapLayer = async (url, leafletOptions) => {
  let prevLayer = null;

  const response = await fetch(url);

  if (!response.ok) {
    throw new Error("Unable to fetch indexMapLayer document", url);
  }

  const data = await response.json();

  // name the const geoJSONLayer; we access it self-referentially within the method
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
