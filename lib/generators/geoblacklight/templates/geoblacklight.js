import "blacklight-frontend/app/assets/javascripts/blacklight/blacklight";
import { GeoBlacklightInitializer } from "@geoblacklight/frontend";

// Execute geoblacklight's javascript on all page loads
const initializer = new GeoBlacklightInitializer();
document.addEventListener("turbo:load", initializer.run);
