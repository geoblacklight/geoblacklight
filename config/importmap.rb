# frozen_string_literal: true

# OGM viewer components: the previewer, the map of where a set of records is, and the map of where
# one of them is
pin "ogm-viewer", to: "https://unpkg.com/ogm-viewer@1.0.0/dist/components/ogm-viewer.js"
pin "ogm-overview", to: "https://unpkg.com/ogm-viewer@1.0.0/dist/components/ogm-overview.js"
pin "ogm-locator", to: "https://unpkg.com/ogm-viewer@1.0.0/dist/components/ogm-locator.js"

# OGM viewer library, used for constructing the location previewers handed to the results map.
# Not preloaded because only the pages with that map want it; loaded dynamically there.
pin "ogm-viewer/lib", to: "https://unpkg.com/ogm-viewer@1.0.0/dist/components/index.js", preload: false

# Geoblacklight
pin_all_from Geoblacklight::Engine.root.join("app", "javascript", "geoblacklight"), under: "geoblacklight"
