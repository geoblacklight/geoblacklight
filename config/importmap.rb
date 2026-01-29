# frozen_string_literal: true

# OpenLayers viewer
pin "ol", to: "https://esm.sh/ol@8.1.0"
pin "ol/", to: "https://esm.sh/ol@8.1.0/"
pin "ol-pmtiles", to: "https://cdn.skypack.dev/ol-pmtiles@0.3.0"

# Leaflet viewer
pin "leaflet", to: "https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet-src.esm.js"
pin "esri-leaflet", to: "https://cdn.jsdelivr.net/npm/esri-leaflet@3.0.19/+esm"
pin "leaflet.fullscreen", to: "https://cdn.jsdelivr.net/npm/leaflet.fullscreen@5.3.0/+esm"

# Geoblacklight
pin_all_from Geoblacklight::Engine.root.join("app", "javascript", "geoblacklight"), under: "geoblacklight"
