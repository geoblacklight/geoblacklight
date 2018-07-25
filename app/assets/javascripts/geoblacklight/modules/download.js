Blacklight.onLoad(function() {
  $('[data-download-path]').each(function(i, element) {
    GeoBlacklight.downloader(element);
  });
  $('#blacklight-modal').on('loaded.blacklight.blacklight-modal', function() {
    var modal = this;
    $(this).find('#hglRequest').each(function() {
      GeoBlacklight.hglDownloader(this, { modal: modal });
    });
  });
});
