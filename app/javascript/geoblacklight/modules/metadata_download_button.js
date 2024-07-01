class GeoBlacklightMetadataDownloadButton extends L.Class {
  constructor(el, i, options = {}) {
    super();

    L.Util.setOptions(this, options);
    this.el = typeof el === "string" ? document.querySelector(el) : el;
    this.download = document.querySelector(
      this.options.target || this.el.getAttribute("data-ref-download")
    );
    // On initialization only do this for the first one.
    if (i === 0) {
      this.setRefUrl();
    }
    this.configureHandler();
  }

  configureHandler() {
    this.el.addEventListener("click", () => this.setRefUrl());
  }

  setRefUrl() {
    const refUrl = this.el.getAttribute("data-ref-endpoint");
    if (!refUrl) {
      this.download.style.display = "none";
    } else {
      this.download.style.display = "";
      this.download.setAttribute("href", refUrl);
    }
  }
}

// Basic support of CommonJS module
if (typeof exports === "object") {
  module.exports = GeoBlacklightMetadataDownloadButton;
}

export default GeoBlacklightMetadataDownloadButton;
