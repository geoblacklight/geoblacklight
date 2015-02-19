Blacklight.onLoad(function() {
  $('#content')
    .on('click', '#documents [data-layer-id]', function() {
      $(this).find('.collapse').collapse('toggle');
      $(this).find('.caret-toggle').toggleClass('open');
    });
});
