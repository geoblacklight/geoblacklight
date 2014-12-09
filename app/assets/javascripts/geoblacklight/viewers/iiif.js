//= require geoblacklight/viewers/viewer.js
//= require openseadragon

GeoBlacklight.Viewer.Iiif = GeoBlacklight.Viewer.extend({
  load: function() {
    this.osdConfig = {
      id: this.element.id,
      prefixUrl: '/assets/osd/',
      preserveViewport: true,
      showNavigator:  false,
      visibilityRatio: 1,
      minZoomLevel: 1,
      tileSources: [this.data.url]
    };

    this.adjustLayout();
    OpenSeadragon(this.osdConfig);
  },

  adjustLayout: function() {

    // hide attribute table
    $('#table-container').hide();

    // expand viewer element
    $(this.element).parent().attr('class', 'col-md-12');
  }
});
