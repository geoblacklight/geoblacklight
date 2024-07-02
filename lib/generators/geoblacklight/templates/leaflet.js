import "leaflet/dist/leaflet.css";
import "leaflet-fullscreen/dist/leaflet.fullscreen.css";
import { LeafletInitializer } from "@geoblacklight/frontend";

document.addEventListener("DOMContentLoaded", () => {
  new LeafletInitializer().run();
});
