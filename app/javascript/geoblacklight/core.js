// Initializers
import initializePopovers from "geoblacklight/initializers/popovers"
import initializeTooltips from "geoblacklight/initializers/tooltips"
import initializeTruncation from "geoblacklight/initializers/truncation"
import initializeFieldTruncation from "geoblacklight/initializers/field_truncation"
import initializeMetadataDownload from "geoblacklight/initializers/metadata_download"
import initializeViewerTheme from "geoblacklight/initializers/viewer_theme"
import initializeViewerRequests from "geoblacklight/initializers/viewer_requests"

// Stimulus controllers
import ClipboardController from "geoblacklight/controllers/clipboard_controller"
import OembedViewerController from "geoblacklight/controllers/oembed_viewer_controller"
import OverviewMapController from "geoblacklight/controllers/overview_map_controller"

// Inspired by Blacklight's javascript/blacklight/core.js
const Geoblacklight = (function () {
  const callbacks = []
  return {
    // Hook: pass a callback to add it to the activation stack
    onLoad: function (callback) {
      callbacks.push(callback)
    },

    // Activate all stored callbacks
    activate: function (event) {
      callbacks.forEach((callback) => {
        callback(event)
      })
    },

    // Define hooks that will trigger the activation of the Geoblacklight JS
    listeners: function () {
      if (typeof Turbo !== "undefined") return ["turbo:load", "turbo:frame-load"]
      else return ["DOMContentLoaded"]
    },
  }
})()

// Add event listeners that call activate() for each event type
Geoblacklight.listeners().forEach((listener) =>
  document.addEventListener(listener, (event) => Geoblacklight.activate(event)),
)

// Register our initializers
Geoblacklight.onLoad(initializePopovers)
Geoblacklight.onLoad(initializeTooltips)
Geoblacklight.onLoad(initializeTruncation)
Geoblacklight.onLoad(initializeFieldTruncation)
Geoblacklight.onLoad(initializeMetadataDownload)
Geoblacklight.onLoad(initializeViewerTheme)
Geoblacklight.onLoad(initializeViewerRequests)

// Register our Stimulus controllers
if (typeof Stimulus !== "undefined") {
  Stimulus.register("oembed-viewer", OembedViewerController)
  Stimulus.register("overview-map", OverviewMapController)
  Stimulus.register("clipboard", ClipboardController)
} else {
  console.error(
    "Couldn't find Stimulus. Check installation instructions at https://github.com/hotwired/stimulus-rails.",
  )
}

export default Geoblacklight
