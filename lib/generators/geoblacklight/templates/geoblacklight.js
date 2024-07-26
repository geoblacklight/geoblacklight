import { application } from "../controllers/application";
import {
  CloverViewerController,
  LeafletViewerController,
  OpenlayersViewerController,
  OembedViewerController,
  SearchResultsController,
  GeoBlacklightInitializer,
  DownloadsController,
  ClipboardController,
} from "@geoblacklight/frontend";

// Register stimulus controllers
application.register("clover-viewer", CloverViewerController);
application.register("leaflet-viewer", LeafletViewerController);
application.register("oembed-viewer", OembedViewerController);
application.register("openlayers-viewer", OpenlayersViewerController);
application.register("search-results", SearchResultsController);
application.register("downloads", DownloadsController);
application.register("clipboard", ClipboardController);

// Execute geoblacklight's javascript on all page loads
const initializer = new GeoBlacklightInitializer();
document.addEventListener("turbo:load", initializer.run);
