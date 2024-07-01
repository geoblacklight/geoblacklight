class GeoBlacklightLeafletPlugin extends L.Class {
  static debounce(fn, delay) {
    let timeout = null;
    return function(...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        fn.apply(this, args);
      }, delay);
    };
  }
}

L.bboxToBounds = (bbox) => {
  bbox = bbox.split(' ');
  if (bbox.length === 4) {
    return L.latLngBounds([[parseFloat(bbox[1]), parseFloat(bbox[0])], [parseFloat(bbox[3]), parseFloat(bbox[2])]]);
  } else {
    throw new Error("Invalid bounding box string");
  }
};

L.geoJSONToBounds = (geojson) => {
  const layer = L.geoJSON(geojson);
  return layer.getBounds();
};

// Hash for leaflet controls.
GeoBlacklightLeafletPlugin.Controls = {};

// Export the GeoBlacklight class
export default GeoBlacklightLeafletPlugin;
