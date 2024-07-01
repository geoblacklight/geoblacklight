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
import GeoBlacklightLeafletPlugin from './leaflet_plugin.js';
import './basemaps.js';
import './controls/fullscreen.js';
import './controls/opacity.js';
import "./modules/bookmarks.js"
import "./modules/download.js"
import "./modules/popover.js"
import "./modules/map_home.js"
import "./modules/map_item.js"
import "./modules/layer_opacity_control.js"
import "./modules/metadata.js"
import "./modules/relations.js"
import "./modules/results.js"
import "./modules/tooltips.js"
import GeoBlacklightDownloader from './downloaders/downloader.js';
import GeoBlacklightHglDownloader from './downloaders/hgl_downloader.js';
import GeoBlacklightMetadataDownloadButton from './modules/metadata_download_button.js';
import GeoBlacklightViewer from './viewers/viewer.js';
import GeoBlacklightViewerCog from "./viewers/cog.js";
import GeoBlacklightViewerMap from './viewers/map.js';
import GeoBlacklightViewerEsri from './viewers/esri.js';
import GeoBlacklightViewerEsriDynamicMapLayer from './viewers/esri/dynamic_map_layer.js';
import GeoBlacklightViewerEsriFeatureLayer from './viewers/esri/feature_layer.js';
import GeoBlacklightViewerEsriImageMapLayer from './viewers/esri/image_map_layer.js';
import GeoBlacklightViewerEsriTiledMapLayer from './viewers/esri/tiled_map_layer.js';
import GeoBlacklightViewerIiif from './viewers/iiif.js';
import GeoBlacklightViewerIndexMap from './viewers/index_map.js';
import GeoBlacklightViewerOembed from './viewers/oembed.js';
import GeoBlacklightViewerPmtiles from "./viewers/pmtiles.js";
import GeoBlacklightViewerTileJson from './viewers/tilejson.js';
import GeoBlacklightViewerTms from './viewers/tms.js';
import GeoBlacklightViewerWms from './viewers/wms.js';
import GeoBlacklightViewerWmts from './viewers/wmts.js';
import GeoBlacklightViewerXyz from './viewers/xyz.js';

export default {
  Blacklight,
  linkify,
  linkifyHtml,
  GeoBlacklightLeafletPlugin,
  GeoBlacklightDownloader,
  GeoBlacklightHglDownloader,
  GeoBlacklightMetadataDownloadButton,
  GeoBlacklightViewer,
  GeoBlacklightViewerCog,
  GeoBlacklightViewerMap,
  GeoBlacklightViewerEsri,
  GeoBlacklightViewerEsriDynamicMapLayer,
  GeoBlacklightViewerEsriFeatureLayer,
  GeoBlacklightViewerEsriImageMapLayer,
  GeoBlacklightViewerEsriTiledMapLayer,
  GeoBlacklightViewerIiif,
  GeoBlacklightViewerIndexMap,
  GeoBlacklightViewerOembed,
  GeoBlacklightViewerPmtiles,
  GeoBlacklightViewerTileJson,
  GeoBlacklightViewerTms,
  GeoBlacklightViewerWms,
  GeoBlacklightViewerWmts,
  GeoBlacklightViewerXyz,
}
