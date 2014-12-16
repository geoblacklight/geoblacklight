Blacklight.onLoad(function() {
  $('[data-download-path]').each(function(i, element) {
    GeoBlacklight.downloader(element);
  });
  $('#ajax-modal').on('loaded.blacklight.ajax-modal', function() {
    var modal = this;
    $(this).find('#hglRequest').each(function() {
      GeoBlacklight.hglDownloader(this, { modal: modal });
    });
  });
});
