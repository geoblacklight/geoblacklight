import GeoBlacklightDownloader from "./downloaders/downloader";
import GeoBlacklightHglDownloader from "./downloaders/hgl_downloader";

export default function initializeDownloads() {
  document.querySelectorAll("[data-download-path]").forEach((element) => {
    new GeoBlacklightDownloader(element);
  });

  const modalElement = document.getElementById("blacklight-modal");
  modalElement.addEventListener("loaded.blacklight.blacklight-modal", () => {
    modalElement.querySelectorAll("#hglRequest").forEach((element) => {
      new GeoBlacklightHglDownloader(element, {
        modal: modalElement,
      });
    });
  });
}
