//= require bootstrap/tab

!(function(global) {

  /** Download button for the metadata Bootstrap Modal dialog */
  var MetadataDownloadButton = L.Class.extend({
    options: {
      target: '#btn-metadata-download'
    },

    /**
     * Initialize with the DOM element
     * @param {Element} el - <button>, <a>, or other jQuery selector
     * @param {Object} options - Properties for the new instance
     */
    initialize: function initialize(el, options) {
      L.Util.setOptions(this, options);
      this.$el = $(el);
      this.$download = $(this.target || this.$el.data('ref-download'));
      this.configureHandler();
    },

    /**
     * Bind Elements to DOM element event listeners using jQuery
     */
    configureHandler: function configureHandler() {
      this.$el.on('click',L.Util.bind(this.updateRefUrl, this));
    },

    /**
     * Determines if the URL for the download button element has been set
     */
    refUrlIsSet: function refUrlIsSet() {
      return !(this.$download.attr('href') == null || this.$download.attr('href').length === 0)
    },

    /**
     * Hides or shows the download button (depending upon whether or not the download URL has been set)
     */
    updateDownloadDisplay: function updateDownloadDisplay() {
      if(!this.refUrlIsSet()) {
        this.$download.hide();
      } else {
        this.$download.show();
      }
    },

    /**
     * Set the hyperlink URL using the metadata URI
     */
    updateRefUrl: function setRefUrl() {
      var refUrl = this.$el.data('ref-endpoint');
      this.$download.attr('href', refUrl);
      this.updateDownloadDisplay();
    }
  });

  global.GeoBlacklight.MetadataDownloadButton = MetadataDownloadButton;
  global.GeoBlacklight.metadataDownloadButton = function metadataDownloadButton(el, options) {
    return new MetadataDownloadButton(el, options);
  };
})(this);
