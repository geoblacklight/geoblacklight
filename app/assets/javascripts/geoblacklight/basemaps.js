// basemaps

GeoBlacklight.Basemaps = {
  darkMatter: L.tileLayer(
    'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  positron: L.tileLayer(
    'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  )
};
