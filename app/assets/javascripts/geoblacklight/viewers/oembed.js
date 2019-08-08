//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Oembed = GeoBlacklight.Viewer.extend({
  load: function() {
    var $el = $(this.element);
    $.getJSON(this.data.url, function(data){
      if (data === null){
        return;
      }
      $el.html(data.html);
    });
  },
});
