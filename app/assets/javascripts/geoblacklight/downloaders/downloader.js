!(function(global) {
  'use strict';

  var Downloader = L.Class.extend({
    options: {
      spinner: $('<div class="spinner-border spinner-border-sm float-right" role="status"><span class="sr-only">Downloading</span></div>')
    },

    initialize: function(el, options) {
      L.Util.setOptions(this, options);
      this.$el = $(el);
      this.options.spinner.hide();
      $('.exports .card-header').append(this.options.spinner);
      this.configureHandler();
    },

    configureHandler: function() {
      this.$el.on('click', L.Util.bind(this.download, this));
    },

    download: function(ev) {
      ev.preventDefault();
      if (this.downloading) {
        return;
      }
      this.downloading = true;
      var url = this.$el.data('downloadPath');
      this.options.spinner.show();
      $.getJSON(url)
        .done(L.Util.bind(this.complete, this))
        .fail(L.Util.bind(this.error, this));
    },

    complete: function(data) {
      this.downloading = false;
      this.$el.prop('disabled', false);
      this.renderMessage(data);
      this.options.spinner.hide();
    },

    error: function(data) {
      this.downloading = false;
      this.$el.prop('disabled', false);
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
