// ALL imports in this dir, including in files imported, should be RELATIVE
// paths to keep things working in the various ways these files get used, at
// both compile time and npm package run time.

// NOTE: Requires Leaflet and Esri Leaflet to be loaded via a CDN
// 
// leaflet
// esri-leaflet

// Vendors
import "leaflet-fullscreen/dist/Leaflet.fullscreen.js";
import 'leaflet-iiif';
import * as linkify from 'linkifyjs';
import linkifyHtml from 'linkify-html';

// Blacklight
import 'blacklight-frontend';

// GeoBlacklight
import GeoBlacklight from './geoblacklight.js';
import './basemaps.js';
import './controls/fullscreen.js';
import './controls/opacity.js';
import "./modules/bookmarks.js"
import "./modules/download.js"
import "./modules/help_text.js"
import "./modules/home.js"
import "./modules/item.js"
import "./modules/layer_opacity.js"
import "./modules/metadata.js"
import "./modules/relations.js"
import "./modules/results.js"
import "./modules/svg_tooltips.js"
import GeoBlacklightDownloader from './downloaders/downloader.js';
import GeoBlacklightHglDownloader from './downloaders/hgl_downloader.js';
import GeoBlacklightMetadataDownloadButton from './modules/metadata_download_button.js';
import GeoBlacklightViewer from './viewers/viewer.js';
import GeoBlacklightViewerMap from './viewers/map.js';
import GeoBlacklightViewerEsri from './viewers/esri.js';
import GeoBlacklightViewerEsriDynamicMapLayer from './viewers/esri/dynamic_map_layer.js';
import GeoBlacklightViewerEsriFeatureLayer from './viewers/esri/feature_layer.js';
import GeoBlacklightViewerEsriImageMapLayer from './viewers/esri/image_map_layer.js';
import GeoBlacklightViewerEsriTiledMapLayer from './viewers/esri/tiled_map_layer.js';
import GeoBlacklightViewerIiif from './viewers/iiif.js';
import GeoBlacklightViewerIndexMap from './viewers/index_map.js';
import GeoBlacklightViewerOembed from './viewers/oembed.js';
import GeoBlacklightViewerTilejson from './viewers/tilejson.js';
import GeoBlacklightViewerTms from './viewers/tms.js';
import GeoBlacklightViewerWms from './viewers/wms.js';
import GeoBlacklightViewerWmts from './viewers/wmts.js';
import GeoBlacklightViewerXyz from './viewers/xyz.js';

export default {
  Blacklight,
  linkify,
  linkifyHtml,
  GeoBlacklight,
  GeoBlacklightDownloader,
  GeoBlacklightHglDownloader,
  GeoBlacklightMetadataDownloadButton,
  GeoBlacklightViewer,
  GeoBlacklightViewerMap,
  GeoBlacklightViewerEsri,
  GeoBlacklightViewerEsriDynamicMapLayer,
  GeoBlacklightViewerEsriFeatureLayer,
  GeoBlacklightViewerEsriImageMapLayer,
  GeoBlacklightViewerEsriTiledMapLayer,
  GeoBlacklightViewerIiif,
  GeoBlacklightViewerIndexMap,
  GeoBlacklightViewerOembed,
  GeoBlacklightViewerTilejson,
  GeoBlacklightViewerTms,
  GeoBlacklightViewerWms,
  GeoBlacklightViewerWmts,
  GeoBlacklightViewerXyz,
}