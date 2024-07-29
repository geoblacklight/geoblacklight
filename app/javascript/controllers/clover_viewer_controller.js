import { createElement } from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";
import Image from "@samvera/clover-iiif/image";
import { Controller } from "@hotwired/stimulus";

const viewerOptions = {
  showTitle: false,
  showIIIFBadge: false,
  informationPanel: {
    renderToggle: false,
    renderAbout: false,
  },
};

export default class CloverViewerController extends Controller {
  static values = {
    url: String,
    protocol: String,
  };

  connect() {
    const root = createRoot(this.element);
    root.render(this.getViewer(this.protocolValue, this.urlValue));
  }

  getViewer(protocol, url) {
    if (protocol == "Iiif") {
      // Create a wrapper div with inline style, as recommended in the docs:
      // https://samvera-labs.github.io/clover-iiif/docs/image#react
      return createElement(
        "div",
        { style: { height: 400 } },
        createElement(Image, {
          src: url.replace(/\/info\.json$/, ""),
          isTiledImage: true,
        })
      );
    }
    if (protocol == "IiifManifest")
      return createElement(Viewer, {
        iiifContent: url,
        options: viewerOptions,
      });
    console.error(`Unsupported protocol name: "${protocol}"`);
  }
}
