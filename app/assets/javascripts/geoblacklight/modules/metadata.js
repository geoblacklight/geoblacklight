Blacklight.onLoad(function() {
  $('#blacklight-modal').on('loaded.blacklight.blacklight-modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().addClass('metadata-modal');
    });
    $(this).find('.pill-metadata').each(function(i, element) {
      GeoBlacklight.metadataDownloadButton(element, i);
    });
  });
  $('#blacklight-modal').on('hidden.bs.modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().removeClass('metadata-modal');
    });
  });
});
