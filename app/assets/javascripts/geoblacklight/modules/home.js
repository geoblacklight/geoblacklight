Blacklight.onLoad(function () {
  $('[data-map="home"]').each(function(i, element) {
    var options = {
    /**
    * Initial bounds of map
    * @type {L.LatLngBounds}
    */
    bbox: [[-85, -180], [85, 180]]
    };

    var geoblacklight = new GeoBlacklight.Viewer.Leaflet(this, options),
        data = $(this).data();
    geoblacklight.map.addControl(L.control.geosearch({
      baseUrl: data.catalogPath,
      dynamic: false,
      searcher: function() {
      window.location.href = this.getSearchUrl();
      },
      staticButton: '<a class="btn btn-primary">Search Here</a>'
    }));
  });
});