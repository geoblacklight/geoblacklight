import "leaflet/dist/leaflet.css";
import "leaflet-fullscreen/dist/leaflet.fullscreen.css";
import { LeafletInitializer } from "@geoblacklight/frontend";

const initializer = new LeafletInitializer();
document.addEventListener("turbo:load", initializer.run)
