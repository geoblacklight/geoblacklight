import GeoBlacklightHglDownloader from "./downloaders/hgl_downloader";

export default function initializeDownloads() {
  const modalElement = document.getElementById("blacklight-modal");
  modalElement.addEventListener("loaded.blacklight.blacklight-modal", () => {
    modalElement.querySelectorAll("#hglRequest").forEach((element) => {
      new GeoBlacklightHglDownloader(element, {
        modal: modalElement,
      });
    });
  });
}
