// basemaps

GeoBlacklight.Basemaps = {
  darkMatter: L.tileLayer(
    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  positron: L.tileLayer(
    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  positronLite: L.tileLayer(
    'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  worldAntique: L.tileLayer(
    'https://cartocdn_{s}.global.ssl.fastly.net/base-antique/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  worldEco: L.tileLayer(
    'https://cartocdn_{s}.global.ssl.fastly.net/base-eco/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  flatBlue: L.tileLayer(
    'https://cartocdn_{s}.global.ssl.fastly.net/base-flatblue/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  ),
  midnightCommander: L.tileLayer(
    'https://cartocdn_{s}.global.ssl.fastly.net/base-midnight/{z}/{x}/{y}{retina}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
      maxZoom: 18,
      worldCopyJump: true,
      retina: '@2x',
      detectRetina: false
    }
  )
};
