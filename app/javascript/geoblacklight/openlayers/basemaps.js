export default {
  darkMatter: {
    url:'https://{a-d}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
    attributions: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributionss">Carto</a>',
    maxZoom: 18
  },
  positron: {
    url: 'https://{a-d}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    attributions: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributionss">Carto</a>',
    maxZoom: 18
  },
  positronLite: {
    url: 'https://{a-d}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
    attributions: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributionss">Carto</a>',
    maxZoom: 18
  },
  openstreetmapHot: {
    url: 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    attributions: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>', 
    maxZoom: 19
  },
  openstreetmapStandard: {
    url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attributions: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  }
}
