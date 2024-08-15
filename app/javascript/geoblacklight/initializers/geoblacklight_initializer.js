import initializePopovers from "./popovers.js";
import initializeRelations from "./relations.js";
import initializeTooltips from "./tooltips.js";
import initializeTruncation from "./truncation.js";
import initializeDownloads from "./downloads.js";
import initializeMetadataDownload from "./metadata_download.js";

export default class GeoBlacklightInitializer {
  run() {
    initializeRelations();
    initializeTruncation();
    initializePopovers();
    initializeTooltips();
    initializeDownloads();
    initializeMetadataDownload();
  }
}
