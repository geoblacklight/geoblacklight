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
     * @param {Number} i - index of metadata item
     * @param {Object} options - Properties for the new instance
     */
    initialize: function initialize(el, i, options) {
      L.Util.setOptions(this, options);
      this.$el = $(el);
      this.$download = $(this.target || this.$el.data('ref-download'));
      // On initialization only do this for the first one.
      if (i === 0) {
        this.setRefUrl();
      }
      this.configureHandler();
    },

    /**
     * Bind Elements to DOM element event listeners using jQuery
     */
    configureHandler: function configureHandler() {
      this.$el.on('click', L.Util.bind(this.setRefUrl, this));
    },

    /**
     * Set the hyperlink URL using the metadata URI
     */
    setRefUrl: function setRefUrl() {
      var refUrl = this.$el.data('ref-endpoint');
      if(refUrl == null || refUrl.length === 0) {
        this.$download.hide();
      } else {
        this.$download.show();
        this.$download.attr('href', refUrl);
      }
    },
  });

  global.GeoBlacklight.MetadataDownloadButton = MetadataDownloadButton;
  global.GeoBlacklight.metadataDownloadButton = function metadataDownloadButton(el, options) {
    return new MetadataDownloadButton(el, options);
  };
})(this);
