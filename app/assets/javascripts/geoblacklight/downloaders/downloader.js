!(function(global) {
  'use strict';

  var Downloader = L.Class.extend({
    options: {
      spinner: $('<i class="fa fa-spinner fa-spin fa-2x fa-align-center"></i>')
    },

    initialize: function(el, options) {
      L.Util.setOptions(this, options);
      this.$el = $(el);
      this.configureHandler();
    },

    configureHandler: function() {
      this.$el.on('click', L.Util.bind(this.download, this));
    },

    download: function(ev) {
      var url = this.$el.data('downloadPath');
      ev.preventDefault();
      this.$el.closest('.btn-group').append(this.options.spinner);
      $.getJSON(url)
        .done(L.Util.bind(this.complete, this))
        .fail(L.Util.bind(this.error, this));
    },

    complete: function(data) {
      this.renderMessage(data);
      this.options.spinner.hide();
    },

    error: function(data) {
      this.options.spinner.hide();
    },

    renderMessage: function(message) {
      $.each(message, function(idx, msg) {
        var flash = '<div class="alert alert-' + msg[0] + '"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' + msg[1] + '</div>';
        $('div.flash_messages').append(flash);
      });
    }

  });

  global.GeoBlacklight.Downloader = Downloader;
  global.GeoBlacklight.downloader = function(el, options) {
    return new Downloader(el, options);
  };

})(this);
