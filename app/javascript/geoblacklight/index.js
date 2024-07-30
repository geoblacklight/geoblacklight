// Stimulus controllers
import OpenlayersViewerController from "./controllers/openlayers_viewer_controller";
import CloverViewerController from "./controllers/clover_viewer_controller";
import OembedViewerController from "./controllers/oembed_viewer_controller";
import LeafletViewerController from "./controllers/leaflet_viewer_controller";
import SearchResultsController from "./controllers/search_results_controller";
import DownloadsController from "./controllers/downloads_controller";
import ClipboardController from "./controllers/clipboard_controller";

// Other modules
import openLayersBasemaps from "./openlayers/basemaps";
import leafletBasemaps from "./leaflet/basemaps";

// Core
import Core from "./core";

export default {
  OpenlayersViewerController,
  CloverViewerController,
  OembedViewerController,
  LeafletViewerController,
  SearchResultsController,
  DownloadsController,
  ClipboardController,
  openLayersBasemaps,
  leafletBasemaps,
  Core,
};
