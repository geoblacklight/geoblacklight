import { latLngBounds, formatNum, geoJSON } from "leaflet";

export const bboxToBounds = (bbox) => {
  bbox = bbox.split(" ");
  if (bbox.length === 4) {
    return latLngBounds([
      [parseFloat(bbox[1]), parseFloat(bbox[0])],
      [parseFloat(bbox[3]), parseFloat(bbox[2])],
    ]);
  } else {
    throw new Error("Invalid bounding box string");
  }
};

export const boundsToBbox = (bounds) => {
  let sw = bounds.getSouthWest(),
    ne = bounds.getNorthEast();

  if (ne.lng - sw.lng >= 360) {
    sw.lng = -180;
    ne.lng = 180;
  }
  sw = sw.wrap();
  ne = ne.wrap();
  return [
    formatNum(sw.lng, 6),
    formatNum(sw.lat, 6),
    formatNum(ne.lng, 6),
    formatNum(ne.lat, 6),
  ];
};

export const geoJSONToBounds = (geojson) => {
  const layer = geoJSON(geojson);
  return layer.getBounds();
};

export const debounce = (fn, delay) => {
  let timeout = null;
  return function (...args) {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      fn.apply(this, args);
    }, delay);
  };
};
