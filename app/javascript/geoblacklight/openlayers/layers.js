// import { layer, style } from "ol";
// import VectorTile from "ol/layer/VectorTile";
// import { Style, Stroke, Fill, Circle } from "ol/style";
import { PMTilesVectorSource } from "ol-pmtiles";
// import { useGeographic } from "ol/proj";
// import GeoTIFF from "ol/source/GeoTIFF";
// import WebGLTileLayer from "ol/layer/WebGLTile";
import ol from "ol";

// Create a new PMTiles layer
export const pmTilesLayer = (url) => {
  ol.proj.useGeographic();
  return new ol.layer.VectorTile({
    declutter: true,
    source: new PMTilesVectorSource({ url }),
    style: new ol.style.Style({
      stroke: new ol.style.Stroke({
        color: "#7070B3",
        width: 1,
      }),
      fill: new ol.style.Fill({
        color: "#FFFFFF",
      }),
      image: new ol.style.Circle({
        radius: 7,
        fill: new ol.style.Fill({
          color: "#7070B3",
        }),
        stroke: new ol.style.Stroke({
          color: "#FFFFFF",
          width: 2,
        }),
      }),
    }),
  });
};

// Create a new cloud-optimized GeoTIFF (COG) layer
export const cogLayer = (url) => {
  return new ol.layer.WebGLTileLayer({
    source: new ol.source.GeoTIFF({
      sources: [{ url }],
      convertToRGB: true,
    }),
  });
};
