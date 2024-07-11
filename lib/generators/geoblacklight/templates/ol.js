import "ol/ol.css"
import { OlInitializer } from '@geoblacklight/frontend'

const initializer = new OlInitializer();
document.addEventListener("turbo:load", initializer.run);
