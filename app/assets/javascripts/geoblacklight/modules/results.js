Blacklight.onLoad(function() {
  var dynamicSearcher;

  dynamicSearcher = GeoBlacklight.debounce(function(querystring) {
    History.pushState(null, null, "/catalog?" + querystring);
  }, 800);

  History.Adapter.bind(window, 'statechange', function() {
    var state = History.getState();
    updatePage(state.url);
  });

  $('[data-map="index"]').each(function() {
    var geoblacklight = new GeoBlacklight(this).setHoverListeners(),
        search = new L.Control.GeoSearch(dynamicSearcher);
    geoblacklight.map.addControl(search);
  });

  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
          $doc = $(resp);
      $("#documents").replaceWith($doc.find("#documents"));
      $("#sidebar").replaceWith($doc.find("#sidebar"));
      $("#sortAndPerPage").replaceWith($doc.find("#sortAndPerPage"));
      if ($("#map").next().length) {
        $("#map").next().replaceWith($doc.find("#map").next());
      } else {
        $("#map").after($doc.find("#map").next());
      }
    });
  }

});

GeoBlacklight.prototype.setHoverListeners = function() {
  var _this = this;

  $("#content")
    .on("mouseenter", "#documents [data-layer-id]", function() {
      var bounds = L.bboxToBounds($(this).data('bbox'));
      _this.addBoundsOverlay(bounds);
    })
    .on("mouseleave", "#documents [data-layer-id]", function() {
      _this.removeBoundsOverlay();
    });

  return this;

};
