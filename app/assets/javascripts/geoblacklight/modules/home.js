Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element) {
    var geoblacklight = new GeoBlacklight(this),
        search;
    search = new L.Control.GeoSearch(function(querystring) {
      this.link.href = "/catalog?" + querystring;
    }, { button: true });
    geoblacklight.map.addControl(search);
  });
});
