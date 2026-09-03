// basemaps

/**
* Raster XYZ tile definitions for the basemaps GeoBlacklight ships with. Each
* definition is passed to L.tileLayer as its options, so it carries the URL
* template alongside the layer options it needs.
*
* Applications can change any of these, or add their own, by setting
* LEAFLET.BASEMAPS in settings.yml. See selectBasemap in viewers/map.js.
*/
GeoBlacklight.BasemapDefinitions = {
  darkMatter: {
    url: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  positron: {
    url: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  positronLite: {
    url: 'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  worldAntique: {
    url: 'https://cartocdn_{s}.global.ssl.fastly.net/base-antique/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  worldEco: {
    url: 'https://cartocdn_{s}.global.ssl.fastly.net/base-eco/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  flatBlue: {
    url: 'https://cartocdn_{s}.global.ssl.fastly.net/base-flatblue/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  midnightCommander: {
    url: 'https://cartocdn_{s}.global.ssl.fastly.net/base-midnight/{z}/{x}/{y}{retina}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
    maxZoom: 18,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  openstreetmapHot: {
    url: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>',
    maxZoom: 19,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  },
  openstreetmapStandard: {
    url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19,
    worldCopyJump: true,
    retina: '@2x',
    detectRetina: false
  }
};

/**
* Layer instances for the shipped definitions. Kept so that applications
* referencing or replacing GeoBlacklight.Basemaps entries keep working.
*/
GeoBlacklight.Basemaps = {};

Object.keys(GeoBlacklight.BasemapDefinitions).forEach(function(name) {
  var definition = GeoBlacklight.BasemapDefinitions[name];
  GeoBlacklight.Basemaps[name] = L.tileLayer(definition.url, definition);
});
