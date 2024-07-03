import LeafletViewerBase from "./base.js";

export default class LeafletViewerOembed extends LeafletViewerBase {
  constructor() {
    super();
    this.onLoad();
  }

  onLoad() {
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
