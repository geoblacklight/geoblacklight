Blacklight.onLoad(function() {
  $('[data-map="index"]').each(function(i, el) {
    GeoBlacklight.initialize(el).setHoverListeners();
  });
});

// Blacklight.onLoad doesn't trigger on Turbolinks page:restore event
$(document).on("page:restore", function() {
  $('[data-map="index"]').each(function(i, el) {
    GeoBlacklight.initialize(el).setHoverListeners();
  });
});

GeoBlacklight.setHoverListeners = function() {
  $("#documents")
    .on("mouseenter", "[data-layer-id]", function(el) {
      var bounds = GeoBlacklight.bboxToBounds($(this).data('bbox'));
      GeoBlacklight.addBoundsOverlay(bounds);
    })
    .on("mouseleave", "[data-layer-id]", function(el) {
      GeoBlacklight.removeBoundsOverlay();
    });
};
