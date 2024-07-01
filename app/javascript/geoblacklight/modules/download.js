document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-download-path]").forEach((element) => {
    GeoBlacklight.downloader(element);
  });

  const modalElement = document.getElementById("blacklight-modal");
  modalElement.addEventListener("loaded.blacklight.blacklight-modal", () => {
    modalElement.querySelectorAll("#hglRequest").forEach((element) => {
      GeoBlacklight.hglDownloader(element, { modal: modalElement });
    });
  });
});
