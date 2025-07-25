// Stimulus controllers
import OpenlayersViewerController from "geoblacklight/controllers/openlayers_viewer_controller";
import OembedViewerController from "geoblacklight/controllers/oembed_viewer_controller";
import LeafletViewerController from "geoblacklight/controllers/leaflet_viewer_controller";
import SearchResultsController from "geoblacklight/controllers/search_results_controller";
import DownloadsController from "geoblacklight/controllers/downloads_controller";
import ClipboardController from "geoblacklight/controllers/clipboard_controller";

// GBL core
import Core from "geoblacklight/core";

// Other modules
import openLayersBasemaps from "geoblacklight/openlayers/basemaps";
import leafletBasemaps from "geoblacklight/leaflet/basemaps";

export default {
  OpenlayersViewerController,
  OembedViewerController,
  LeafletViewerController,
  SearchResultsController,
  DownloadsController,
  ClipboardController,
  openLayersBasemaps,
  leafletBasemaps,
  Core,
  onLoad: Core.onLoad,
};
