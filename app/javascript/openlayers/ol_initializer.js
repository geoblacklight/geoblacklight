import '../stylesheets/openlayers.css'
import { Map, View } from 'ol'
import TileLayer from 'ol/layer/Tile'
import VectorTile from 'ol/layer/VectorTile'
import XYZ from 'ol/source/XYZ'
import GeoJSON from 'ol/format/GeoJSON'
import { useGeographic } from 'ol/proj'
import {
  Style, Stroke, Fill, Circle
} from 'ol/style'
import GeoTIFF from 'ol/source/GeoTIFF'
import WebGLTileLayer from 'ol/layer/WebGLTile'
import { FullScreen, defaults as defaultControls } from 'ol/control'
import { PMTilesVectorSource } from 'ol-pmtiles'
import { openLayersBasemaps }  from './basemaps'

export default class OlInitializer {
  constructor () {
    this.element = document.getElementById('ol-map')
    if (this.element) {
      this.data = this.element.dataset
      this.extent = new GeoJSON().readFeatures(this.data.mapGeom)[0].getGeometry().getExtent()
    }
  }

  run () {
    if (!this.element) return false
    if (this.data.protocol === 'Pmtiles') {
      this.initializePmtiles()
    } else if (this.data.protocol === 'Cog') {
      this.initializeCog()
    }
  }

  baseLayer () {
    const basemap = this.basemapDefinition()
    const layer = new TileLayer({
      source: new XYZ({
        attributions: basemap["attribution"],
        url: this.normalizeUrl(basemap["url"]),
        maxZoom: basemap["maxZoom"]
      })
    })
    return layer
  }

  // The basemap to draw, with any BASEMAPS values from settings.yml merged
  // over the shipped definition. This lets an application change a basemap's
  // URL -- to add a CARTO API key, for example -- without restating the rest
  // of the definition, and lets it define basemaps of its own.
  basemapDefinition () {
    const name = this.data.basemap || 'positron'
    const definition = {
      ...openLayersBasemaps[name],
      ...this.basemapOverrides()[name]
    }
    if (definition.url) return definition
    return openLayersBasemaps.positron
  }

  basemapOverrides () {
    return JSON.parse(this.data.leafletOptions || '{}').BASEMAPS || {}
  }

  // Leaflet and OpenLayers spell tile URL templates differently, so accept
  // the Leaflet form a configured basemap is most likely to be written in:
  // {s} becomes OpenLayers' subdomain range, and {retina} drops out.
  normalizeUrl (url) {
    return url.replace(/\{s\}/g, '{a-d}').replace(/\{retina\}/g, '')
  }

  initializePmtiles () {
    const vectorLayer = new VectorTile({
      declutter: true,
      source: new PMTilesVectorSource({
        url: this.data.url
      }),
      style: new Style({
        stroke: new Stroke({
          color: '#7070B3',
          width: 1
        }),
        fill: new Fill({
          color: '#FFFFFF'
        }),
        image: new Circle({
          radius: 7,
          fill: new Fill({
            color: '#7070B3'
          }),
          stroke: new Stroke({
            color: '#FFFFFF',
            width: 2
          })
        })
      })
    })

    useGeographic()
    const map = new Map({
      controls: defaultControls().extend([new FullScreen()]),
      layers: [this.baseLayer(), vectorLayer],
      target: 'ol-map'
    })
    map.getView().fit(this.extent, map.getSize())
  }

  initializeCog () {
    const source = new GeoTIFF({
      sources: [{ url: this.data.url }],
      convertToRGB: true
    })

    source.getView().then((view) => {
      const map = new Map({
        controls: defaultControls().extend([new FullScreen()]),
        target: 'ol-map',
        layers: [
          this.baseLayer(),
          new WebGLTileLayer({
            source
          })
        ],
        view: new View({
          center: view.center
        })
      })
      map.getView().fit(view.extent, map.getSize())
    })
  }
}
