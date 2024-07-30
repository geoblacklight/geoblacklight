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

// Inspired by https://github.com/projectblacklight/blacklight/blob/main/app/javascript/blacklight/core.js
const Geoblacklight = function () {
  return {
    // Everything that should be set up when the Geoblacklight JS is activated
    activate: function () {
      if (typeof Stimulus !== "undefined") {
        Stimulus.register("openlayers-viewer", OpenlayersViewerController);
        Stimulus.register("clover-viewer", CloverViewerController);
        Stimulus.register("oembed-viewer", OembedViewerController);
        Stimulus.register("leaflet-viewer", LeafletViewerController);
        Stimulus.register("search-results", SearchResultsController);
        Stimulus.register("downloads", DownloadsController);
        Stimulus.register("clipboard", ClipboardController);
      }
      initializeRelations();
      initializeTruncation();
      initializePopovers();
      initializeTooltips();
      initializeDownloads();
      initializeMetadataDownload();
    },
    // Define hooks that will trigger the activation of the Geoblacklight JS
    listeners: function () {
      const listeners = [];
      if (typeof Turbo !== "undefined") {
        listeners.push("turbo:load", "turbo:frame-load");
      } else {
        listeners.push("DOMContentLoaded");
      }
      return listeners;
    },
  };
};

Geoblacklight.listeners().forEach((listener) =>
  document.addEventListener(listener, Geoblacklight.activate)
);

export default Geoblacklight;
