import "@popperjs/core";
import "bootstrap";
import GeoBlacklight from '@/geoblacklight/index.js';
import GeoBlacklightDownloader from '@/geoblacklight/downloaders/downloader.js';
import GeoBlacklightHglDownloader from '@/geoblacklight/downloaders/hgl_downloader.js';
import GeoBlacklightMetadataDownloadButton from '@/geoblacklight/modules/metadata_download_button.js';

window.bootstrap = bootstrap;
window.GeoBlacklight = GeoBlacklight;
window.GeoBlacklight.Downloader = GeoBlacklightDownloader;
window.GeoBlacklight.downloader = function(el, options) {
  return new GeoBlacklightDownloader(el, options);
};

window.GeoBlacklight.HglDownloader = GeoBlacklightHglDownloader;
window.GeoBlacklight.hglDownloader = function(el, options) {
  return new HglDownloader(el, options);
};

window.GeoBlacklight.MetadataDownloadButton = GeoBlacklightMetadataDownloadButton;
window.GeoBlacklight.metadataDownloadButton = function(el, i, options) {
  return new GeoBlacklightMetadataDownloadButton(el, i, options);
};

// Set Modal > Metadata Button Download links
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.pill-metadata').forEach((element, i) => {
    GeoBlacklight.metadataDownloadButton(element, i);
  });
});
