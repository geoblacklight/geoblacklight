Blacklight.onLoad(function() {
  $('[data-map="item"]').each(function(i, element) {

    // get viewer module from protocol value and capitalize to match class name
    var viewerName = $(element).data().protocol;
    viewerName = viewerName.charAt(0).toUpperCase() + viewerName.substring(1);

    // get new viewer instance from modulejs and pass in element
    try {
      var viewer = new window["GeoBlacklight"]["Viewer"][viewerName](element); 
      // viewer.load();
    } catch(err) {
      console.info('Error loading viewer');
    };
  });

  $('.truncate-abstract').readmore({
   maxHeight: 60
  });
});