Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element) {
    var geoblacklight = new GeoBlacklight(this),
        data = $(this).data(),
        search;
    search = new L.Control.GeoSearch(function(querystring) {
      this.link.href = data.catalogPath + '?' + querystring;
    }, { button: true });
    geoblacklight.map.addControl(search);
  });
});
