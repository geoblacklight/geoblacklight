import 'leaflet-iiif';
import GeoBlacklightViewer from './viewer.js'

class GeoBlacklightViewerIiif extends GeoBlacklightViewer {
  constructor(el) {
    super(el);
  }

  load() {
    this.adjustLayout();

    this.map = L.map(this.element, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
    });
    //this.loadControls();
    this.iiifLayer = L.tileLayer.iiif(this.data.url).addTo(this.map);
  }

  adjustLayout() {
    // Hide attribute table
    const tableContainer = document.getElementById('table-container');
    if (tableContainer) {
      tableContainer.style.display = 'none';
    }

    // Expand viewer element
    if (this.element.parentNode) {
      this.element.parentNode.className = 'col-md-12';
    }
  }
}

export default GeoBlacklightViewerIiif;
