Blacklight.onLoad(function() {
  $('#blacklight-modal').on('loaded.blacklight.blacklight-modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().addClass('metadata-modal');
    });

    var buttons = [];
    $(this).find('.pill-metadata').each(function(i, element) {
      button = GeoBlacklight.metadataDownloadButton(element);
      buttons.push(button);
    });

    // Always enable the first metadata download (if possible) by default
    if(buttons.length > 0) {
      buttons.shift().updateRefUrl();
    }
  });
  $('#blacklight-modal').on('hidden.bs.modal', function(e) {
    $(e.target).find('.metadata-body').each(function(_i, el) {
      $(el).parent().parent().removeClass('metadata-modal');
    });
  });
});
