export default class GeoBlacklightDownloader {
  constructor(el, options) {
    this.el = el;
    this.options = options || {};
    this.options.spinner = document.createElement("div");
    this.options.spinner.className =
      "spinner-border spinner-border-sm float-right";
    this.options.spinner.role = "status";
    this.options.spinner.innerHTML = '<span class="sr-only">Downloading</span>';
    this.options.spinner.style.display = "none";
    // @TODO: This spinner doesn't appear to work in GBL Proper anymore.
    //document.querySelector('.exports .card-header').appendChild(this.options.spinner);
    this.configureHandler();
  }

  configureHandler() {
    this.el.addEventListener("click", (ev) => this.download(ev));
  }

  download(ev) {
    ev.preventDefault();
    if (this.downloading) {
      return;
    }
    this.downloading = true;
    const url = this.el.getAttribute("data-download-path");
    this.options.spinner.style.display = "block";

    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => this.complete(data))
      .catch((error) => this.error(error));
  }

  complete(data) {
    this.downloading = false;
    this.el.disabled = false;
    this.renderMessage(data);
    this.options.spinner.style.display = "none";
  }

  error(data) {
    console.error("Download error:", data);
    this.downloading = false;
    this.el.disabled = false;
    this.options.spinner.style.display = "none";
  }

  renderMessage(message) {
    Object.entries(message).forEach(([idx, msg]) => {
      const flash = document.createElement("div");
      flash.className = `alert alert-${msg[0]}`;
      flash.innerHTML = `<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>${msg[1]}`;
      document.querySelector("div.flash_messages").appendChild(flash);
    });
  }
}
