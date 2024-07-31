import OpenlayersViewerController from "./controllers/openlayers_viewer_controller";
import CloverViewerController from "./controllers/clover_viewer_controller";
import OembedViewerController from "./controllers/oembed_viewer_controller";
import LeafletViewerController from "./controllers/leaflet_viewer_controller";
import SearchResultsController from "./controllers/search_results_controller";
import DownloadsController from "./controllers/downloads_controller";
import ClipboardController from "./controllers/clipboard_controller";

import initializePopovers from "./popovers";
import initializeRelations from "./relations";
import initializeTooltips from "./tooltips";
import initializeTruncation from "./truncation";
import initializeDownloads from "./downloads";
import initializeMetadataDownload from "./metadata_download";

// Inspired by Blacklight's javascript/blacklight/core.js
const Geoblacklight = (function () {
  const callbacks = [];
  return {
    // Hook: pass a callback to add it to the activation stack
    onLoad: function (callback) {
      callbacks.push(callback);
    },

    // Activate all stored callbacks
    activate: function (event) {
      callbacks.forEach((callback) => {
        callback(event)
      });
    },

    // Define hooks that will trigger the activation of the Geoblacklight JS
    listeners: function () {
      if (typeof Turbo !== "undefined") return ["turbo:load", "turbo:frame-load"];
      else return ["DOMContentLoaded"];
    },
  };
})();

// Add event listeners that call activate() for each event type
Geoblacklight.listeners().forEach((listener) =>
  document.addEventListener(listener, (event) => Geoblacklight.activate(event))
);

// Default activation stack
Geoblacklight.onLoad(initializePopovers);
Geoblacklight.onLoad(initializeRelations);
Geoblacklight.onLoad(initializeTooltips);
Geoblacklight.onLoad(initializeTruncation);
Geoblacklight.onLoad(initializeDownloads);
Geoblacklight.onLoad(initializeMetadataDownload);

// Register our Stimulus controllers
if (typeof Stimulus !== "undefined") {
  Stimulus.register("openlayers-viewer", OpenlayersViewerController);
  Stimulus.register("clover-viewer", CloverViewerController);
  Stimulus.register("oembed-viewer", OembedViewerController);
  Stimulus.register("leaflet-viewer", LeafletViewerController);
  Stimulus.register("search-results", SearchResultsController);
  Stimulus.register("downloads", DownloadsController);
  Stimulus.register("clipboard", ClipboardController);
}
else {
  console.error("Couldn't find Stimulus. Check instructions at https://github.com/hotwired/stimulus-rails");
}

export default Geoblacklight;
