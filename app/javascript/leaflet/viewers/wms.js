import { tileLayer } from "leaflet";
import LeafletViewerMap from "./map.js";

export default class LeafletViewerWms extends LeafletViewerMap {
  onLoad() {
    super.onLoad();
    if (this.available) {
      this.addPreviewLayer();
      this.addControls();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  }

  addPreviewLayer() {
    const wmsLayer = tileLayer.wms(this.data.url, {
      layers: this.data.layerId,
      format: "image/png",
      transparent: true,
      tiled: true,
      CRS: "EPSG:3857",
      opacity: this.options.opacity,
      detectRetina: this.detectRetina(),
    });
    this.overlay.addLayer(wmsLayer);
    this.setupInspection();
  }

  setupInspection() {
    this.map.on("click", async (e) => {
      const spinner = document.createElement("tbody");
      spinner.className = "attribute-table-body";
      spinner.innerHTML =
        '<tr><td colspan="2"><div class="spinner-border" role="status"><span class="sr-only">Inspecting</span></div></td></tr>';
      document.querySelector(".attribute-table-body").replaceWith(spinner);

      const wmsoptions = {
        URL: this.data.url,
        LAYERS: this.data.layerId,
        BBOX: this.map.getBounds().toBBoxString(),
        WIDTH: Math.round(document.getElementById("map").clientWidth),
        HEIGHT: Math.round(document.getElementById("map").clientHeight),
        QUERY_LAYERS: this.data.layerId,
        X: Math.round(e.containerPoint.x),
        Y: Math.round(e.containerPoint.y),
      };

      try {
        const response = await fetch("/wms/handle", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document
              .querySelector('meta[name="csrf-token"]')
              .getAttribute("content"),
          },
          body: JSON.stringify(wmsoptions),
        });

        if (!response.ok) throw new Error("Network response was not ok.");

        const data = await response.json();

        if (data.hasOwnProperty("error") || data.values.length === 0) {
          document.querySelector(".attribute-table-body").innerHTML =
            '<tr><td colspan="2">Could not find that feature</td></tr>';
          return;
        }

        const html = document.createElement("tbody");
        html.className = "attribute-table-body";
        data.values.forEach((val) => {
          html.innerHTML += `<tr><td>${val[0]}</td><td>${val[1]}</td></tr>`; // Note: You might need to implement linkify functionality
        });
        document.querySelector(".attribute-table-body").replaceWith(html);
      } catch (error) {
        console.error("Fetch error: ", error);
      }
    });
  }
}
