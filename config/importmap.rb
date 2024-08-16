# frozen_string_literal: true

# OpenLayers viewer
pin "ol", to: "https://esm.sh/ol@8.1.0"
pin "ol/", to: "https://esm.sh/ol@8.1.0/"
pin "ol-pmtiles", to: "https://cdn.skypack.dev/ol-pmtiles@0.3.0"

# Leaflet viewer
pin "leaflet", to: "https://cdn.skypack.dev/leaflet@1.9.4"
pin "esri-leaflet", to: "https://cdn.skypack.dev/esri-leaflet@3.0.12"
pin "leaflet-fullscreen", to: "https://cdn.skypack.dev/leaflet-fullscreen@1.0.2"

# Clover viewer
pin "react", to: "https://esm.sh/react@18.3.1"
pin "react-dom/client", to: "https://esm.sh/react-dom@18.3.1/client"
pin "@samvera/clover-iiif/viewer", to: "https://esm.sh/@samvera/clover-iiif@2.10.0/dist/viewer"
pin "@samvera/clover-iiif/image", to: "https://esm.sh/@samvera/clover-iiif@2.10.0/dist/image"

# Geoblacklight
pin_all_from Geoblacklight::Engine.root.join("app", "javascript", "geoblacklight"), under: "geoblacklight"
