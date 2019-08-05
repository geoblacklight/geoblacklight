Blacklight.onLoad(function () {
  $('[data-embed-url]').each(function (i, element) {
    var $el = $(element);
    $.getJSON($el.data().embedUrl, function(data){
      if (data === null){
        return;
      }
      $el.html(data.html);
    });
  });
});
