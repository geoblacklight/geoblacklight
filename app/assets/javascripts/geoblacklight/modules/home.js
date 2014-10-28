Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element) {
    GeoBlacklight.initialize(element).setHoverListeners();
  });
});

// Blacklight.onLoad doesn't trigger on Turbolinks page:restore event
$(document).on("page:restore", function() {
  $('[data-map="home"]').each(function(i, el) {
    GeoBlacklight.initialize(el).setHoverListeners();
  });
});
