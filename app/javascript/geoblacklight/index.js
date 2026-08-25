// Stimulus controllers
import OembedViewerController from "geoblacklight/controllers/oembed_viewer_controller"
import OverviewMapController from "geoblacklight/controllers/overview_map_controller"
import ClipboardController from "geoblacklight/controllers/clipboard_controller"

// OpenGeoMetadata web components (each import registers the custom element it is named for)
import "ogm-viewer"
import "ogm-overview"
import "ogm-locator"

// GBL core
import Core from "geoblacklight/core"
import { onViewerRequest } from "geoblacklight/initializers/viewer_requests"

export default {
  OembedViewerController,
  OverviewMapController,
  ClipboardController,
  Core,
  onLoad: Core.onLoad,
  onViewerRequest,
}
