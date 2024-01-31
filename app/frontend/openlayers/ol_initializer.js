import '@/stylesheets/openlayers.css'
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
    const basemap = openLayersBasemaps[this.data.basemap]
    const layer = new TileLayer({
      source: new XYZ({
        attributions: basemap["attribution"],
        url: basemap["url"],
        maxZoom: basemap["maxZoom"]
      })
    })
    return layer
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
      sources: [{ url: this.data.url }]
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
