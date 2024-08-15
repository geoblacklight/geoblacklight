// Initializers
import initializePopovers from "./geoblacklight/popovers";
import initializeRelations from "./geoblacklight/relations";
import initializeTooltips from "./geoblacklight/tooltips";
import initializeTruncation from "./geoblacklight/truncation";
import initializeMetadataDownload from "./geoblacklight/metadata_download";

// Stimulus controllers
import ClipboardController from "./controllers/clipboard_controller";
import CloverViewerController from "./controllers/clover_viewer_controller";
import DownloadsController from "./controllers/downloads_controller";
import LeafletViewerController from "./controllers/leaflet_viewer_controller";
import OembedViewerController from "./controllers/oembed_viewer_controller";
import OpenlayersViewerController from "./controllers/openlayers_viewer_controller";
import SearchResultsController from "./controllers/search_results_controller";

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
        callback(event);
      });
    },

    // Define hooks that will trigger the activation of the Geoblacklight JS
    listeners: function () {
      if (typeof Turbo !== "undefined")
        return ["turbo:load", "turbo:frame-load"];
      else return ["DOMContentLoaded"];
    },
  };
})();

// Add event listeners that call activate() for each event type
Geoblacklight.listeners().forEach((listener) =>
  document.addEventListener(listener, (event) => Geoblacklight.activate(event))
);

// Register our initializers
Geoblacklight.onLoad(initializePopovers);
Geoblacklight.onLoad(initializeRelations);
Geoblacklight.onLoad(initializeTooltips);
Geoblacklight.onLoad(initializeTruncation);
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
} else {
  console.error(
    "Couldn't find Stimulus. Check installation instructions at https://github.com/hotwired/stimulus-rails."
  );
}

export default Geoblacklight;
