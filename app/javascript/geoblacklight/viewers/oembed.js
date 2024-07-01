import GeoBlacklightViewer from "./viewer.js";

class GeoBlacklightViewerOembed extends GeoBlacklightViewer {
  load() {
    const el = document.getElementById(this.element.id);
    fetch(this.data.url)
      .then((response) => response.json())
      .then((data) => {
        if (data === null) {
          return;
        }
        el.innerHTML = data.html;
      })
      .catch((error) => console.error("Error loading oEmbed data:", error));
  }
}

export default GeoBlacklightViewerOembed;
