Blacklight.onLoad(function() {
  $('#ajax-modal').on('loaded.blacklight.ajax-modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().addClass('metadata-modal');
    });
    $(this).find('.pill-metadata').each(function(i, element) {
      GeoBlacklight.metadataDownloadButton(element);
    });
  });
  $('#ajax-modal').on('hidden.bs.modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().removeClass('metadata-modal');
    });
  });
});
