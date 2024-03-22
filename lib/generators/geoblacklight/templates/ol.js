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
//import { openLayersBasemaps }  from './basemaps'

import OlInitializer from '@gbl/openlayers/ol_initializer'

document.addEventListener('DOMContentLoaded', () => {
  new OlInitializer().run()
})
