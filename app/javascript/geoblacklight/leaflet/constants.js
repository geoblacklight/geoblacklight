import { LatLngBounds } from "leaflet";

export const DEFAULT_BOUNDS = new LatLngBounds([
  [-30, -100],
  [30, 100],
]);

export const DEFAULT_OPACITY = 0.75;

export const DEFAULT_BASEMAP = "positron";

export const DEFAULT_GEOM_OVERLAY_OPTIONS = {
  color: '#3388ff',
  dashArray: "5 5",
  weight: 2,
  opacity: 1,
  fillOpacity: 0
}