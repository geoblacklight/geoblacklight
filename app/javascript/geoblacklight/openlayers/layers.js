import { PMTilesVectorSource } from "ol-pmtiles";
import VectorTile from "ol/layer/VectorTile";
import WebGLTileLayer from "ol/layer/WebGLTile";
import { useGeographic } from "ol/proj";
import GeoTIFF from "ol/source/GeoTIFF";
import { Circle, Fill, Stroke, Style } from "ol/style";

// Create a new PMTiles layer
export const pmTilesLayer = (url) => {
  useGeographic();
  return new VectorTile({
    declutter: true,
    source: new PMTilesVectorSource({ url }),
    style: new Style({
      stroke: new Stroke({
        color: "#7070B3",
        width: 1,
      }),
      fill: new Fill({
        color: "#FFFFFF",
      }),
      image: new Circle({
        radius: 7,
        fill: new Fill({
          color: "#7070B3",
        }),
        stroke: new Stroke({
          color: "#FFFFFF",
          width: 2,
        }),
      }),
    }),
  });
};

// Create a new cloud-optimized GeoTIFF (COG) layer
export const cogLayer = (url) => {
  return new WebGLTileLayer({
    source: new GeoTIFF({
      sources: [{ url }],
      convertToRGB: true,
    }),
  });
};
