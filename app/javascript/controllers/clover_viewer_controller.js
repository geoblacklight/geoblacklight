import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import { Controller } from "@hotwired/stimulus";

export default class CloverViewerController extends Controller {
  static values = {
    iiifContent: String,
  };

  connect() {
    const root = createRoot(this.element);
    root.render(
      createElement(Viewer, { id: this.iiifContentValue, options: this.config })
    );
  }

  get config() {
    return {
      showTitle: false,
      showIIIFBadge: false,
      informationPanel: {
        renderToggle: false,
        renderAbout: false,
      },
    }
  }
}
