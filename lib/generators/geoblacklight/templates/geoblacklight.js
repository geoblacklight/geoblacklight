import "bootstrap";
import "blacklight-frontend";
import { GeoBlacklightInitializer } from "@geoblacklight/frontend";

document.addEventListener("DOMContentLoaded", () => {
  new GeoBlacklightInitializer().run();
});
