Blacklight.onLoad(function() {
  $('#ajax-modal').on('loaded.blacklight.ajax-modal', function() {
    $(this).find('.pill-metadata').each(function(i, element) {
      GeoBlacklight.metadataDownloadButton(element);
    });
  });
});
