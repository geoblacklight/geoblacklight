import { JSDOM } from 'jsdom';
import $ from 'jquery';
const GeoBlacklight = require('./app/assets/javascripts/geoblacklight/geoblacklight');

const jsdom = new JSDOM('<html></html>', { pretendToBeVisual: true });
const { window } = jsdom;

global.GeoBlacklight = GeoBlacklight;
global.window = window;
global.jQuery = $;
global.$ = global.jQuery;

import * as L from 'leaflet.js.erb';
global.leaflet = L;
