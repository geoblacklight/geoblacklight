Blacklight.onLoad(function() {
  $('[data-map="bookmarks"]').each(function() {
    var data = $(this).data(),
    world = L.latLngBounds([[-90, -180], [90, 180]]),
    geoblacklight, bbox;

    if (typeof data.mapGeom === 'string') {
      bbox = L.geoJSONToBounds(data.mapGeom);
    } else {
      $('.document [data-geom]').each(function() {
        try {
          var currentBounds = L.geoJSONToBounds($(this).data().geom);
          if (!world.contains(currentBounds)) {
            throw "Invalid bounds";
          }
          if (typeof bbox === 'undefined') {
            bbox = currentBounds;
          } else {
            bbox.extend(currentBounds);
          }
        } catch (e) {
          bbox = L.bboxToBounds("-180 -90 180 90");
        }
      });
    }

    // instantiate new map
    geoblacklight = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });
    geoblacklight.removeBoundsOverlay();

    // set hover listeners on map
    $('#content')
      .on('mouseenter', '#documents [data-layer-id]', function() {
        if($(this).data('bbox') !== "") {
          var geom = $(this).data('geom')
          geoblacklight.addGeoJsonOverlay(geom)
        }
      })
      .on('mouseleave', '#documents [data-layer-id]', function() {
        geoblacklight.removeBoundsOverlay();
      });
  });
});
