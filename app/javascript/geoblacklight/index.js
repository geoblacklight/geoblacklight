// Stimulus controllers
import OembedViewerController from "geoblacklight/controllers/oembed_viewer_controller";
import SearchResultsController from "geoblacklight/controllers/search_results_controller";
import DownloadsController from "geoblacklight/controllers/downloads_controller";
import ClipboardController from "geoblacklight/controllers/clipboard_controller";

// GBL core
import Core from "geoblacklight/core";

export default {
  OembedViewerController,
  SearchResultsController,
  DownloadsController,
  ClipboardController,
  Core,
  onLoad: Core.onLoad,
};
