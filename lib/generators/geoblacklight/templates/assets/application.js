/* Main application javascript entrypoint */

// Turbo & Stimulus
import "@hotwired/turbo-rails";
import { application } from "~/javascript/controllers/application";

// Bootstrap, Blacklight, Geoblacklight
import * as bootstrap from "bootstrap";
import githubAutoCompleteElement from "@github/auto-complete-element";
import Blacklight from "blacklight-frontend";
import Geoblacklight from "@geoblacklight/frontend";

// Make imports available globally to your code
window.bootstrap = bootstrap;
window.Blacklight = Blacklight;
window.Geoblacklight = Geoblacklight;

// Your javascript here!
// console.log('Hello Geoblacklight!')
