import initializePopovers from "./popovers.js";
import initializeRelations from "./relations.js";
import initializeTooltips from "./tooltips.js";
import initializeTruncation from "./truncation.js";

export default class GeoBlacklightInitializer {
  run() {
    initializeRelations();
    initializeTruncation();
    initializePopovers();
    initializeTooltips();
  }
}
