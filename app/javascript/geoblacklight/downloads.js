import GeoBlacklightDownloader from "./downloaders/downloader";

export default function initializeDownloads() {
  const modalElement = document.getElementById("blacklight-modal");
  modalElement.addEventListener("loaded.blacklight.blacklight-modal", () => {
    modalElement.querySelectorAll("[data-download-path]").forEach((element) => {
      new GeoBlacklightDownloader(element, {
        modal: modalElement,
      });
    });
  });
}
