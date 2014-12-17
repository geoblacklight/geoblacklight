//= require geoblacklight/downloaders/downloader

!(function(global) {
  'use strict';

  var HglDownloader = global.GeoBlacklight.Downloader.extend({

    configureHandler: function() {
      this.$el.on('submit', L.Util.bind(this.download, this));
    },

    download: function(ev) {
      var url, email;
      ev.preventDefault();
      $(this.options.modal).modal('hide');
      email = this.$el.find('#requestEmail').val();
      url = this.$el.find('#requestUrl').val();

      $.get(url, { email: email })
        .done(L.Util.bind(this.complete, this))
        .fail(L.Util.bind(this.error, this));
    }

  });

  global.GeoBlacklight.HglDownloader = HglDownloader;
  global.GeoBlacklight.hglDownloader = function(el, options) {
    return new HglDownloader(el, options);
  };


})(this);
