
// IIIF viewer
modulejs.define('viewer/iiif', ['viewer/viewer'], function(Viewer) {
  function IIIFViewer(el) {
    Viewer.apply(this, arguments);

    this.osd_config = {
      id: this.element.id,
      prefixUrl: "/assets/osd/",
      preserveViewport: true,
      showNavigator:  false,
      visibilityRatio: 1,
      minZoomLevel: 1,
      tileSources: [this.data.url]
    };
  };

  IIIFViewer.prototype = Object.create(Viewer.prototype);

  IIIFViewer.prototype.adjustLayout = function() {

    // hide attribute table
    $("#table-container").hide();

    // expand viewer element
    $(this.element).parent().attr('class', 'col-md-12');
  }; 

  IIIFViewer.prototype.load = function() {
    this.adjustLayout();
    OpenSeadragon(this.osd_config);
  };

  return IIIFViewer;
});