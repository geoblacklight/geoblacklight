export class GeoBlacklightMetadataDownloadButton {
  constructor(el, options = {}) {
    this.options = options;
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

export default function initializeMetadataDownload() {
  const modal = document.getElementById("blacklight-modal");

  modal.addEventListener("loaded.blacklight.blacklight-modal", (e) => {
    e.target.querySelectorAll(".metadata-body").forEach((el) => {
      el.closest(".modal-content").classList.add("metadata-modal");
    });

    e.target.querySelectorAll(".pill-metadata").forEach((element, i) => {
      new GeoBlacklightMetadataDownloadButton(element, i);
    });
  });

  modal.addEventListener("hidden.bs.modal", (e) => {
    e.target.querySelectorAll(".metadata-body").forEach((el) => {
      el.closest(".modal-content").classList.remove("metadata-modal");
    });
  });
}
