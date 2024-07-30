import { Controller } from "@hotwired/stimulus";

export default class OembedViewerController extends Controller {
  static values = {
    url: String,
  };

  connect() {
    fetch(this.urlValue)
      .then((response) => response.json())
      .then((data) => {
        if (data) this.element.innerHTML = data.html;
      })
      .catch((error) => {
        console.error("Error loading oEmbed data:", error);
      });
  }
}
