import { Map, View } from "ol";
import TileLayer from "ol/layer/Tile";
import VectorTile from "ol/layer/VectorTile";
import XYZ from "ol/source/XYZ";
import GeoJSON from "ol/format/GeoJSON";
import { useGeographic } from "ol/proj";
import { Style, Stroke, Fill, Circle } from "ol/style";
import GeoTIFF from "ol/source/GeoTIFF";
import WebGLTileLayer from "ol/layer/WebGLTile";
import { FullScreen, defaults as defaultControls } from "ol/control";
import { PMTilesVectorSource } from "ol-pmtiles";
import basemaps from "../modules/openlayers/basemaps";
import { Controller } from "@hotwired/stimulus";

export default class OpenlayersViewerController extends Controller {
  static values = {
    url: String,
    protocol: String,
    mapGeom: String,
    basemap: String,
  };

  connect() {
    this.extent = new GeoJSON()
      .readFeatures(this.mapGeomValue)[0]
      .getGeometry()
      .getExtent();

    if (this.protocolValue === "Pmtiles") {
      this.initializePmtiles();
    } else if (this.protocolValue === "Cog") {
      this.initializeCog();
    }
  }

  get baseLayer() {
    const basemap = basemaps[this.basemapValue];
    const layer = new TileLayer({
      source: new XYZ({
        attributions: basemap["attribution"],
        url: basemap["url"],
        maxZoom: basemap["maxZoom"],
      }),
    });
    return layer;
  }

  initializePmtiles() {
    const vectorLayer = new VectorTile({
      declutter: true,
      source: new PMTilesVectorSource({
        url: this.urlValue,
      }),
      style: new Style({
        stroke: new Stroke({
          color: "#7070B3",
          width: 1,
        }),
        fill: new Fill({
          color: "#FFFFFF",
        }),
        image: new Circle({
          radius: 7,
          fill: new Fill({
            color: "#7070B3",
          }),
          stroke: new Stroke({
            color: "#FFFFFF",
            width: 2,
          }),
        }),
      }),
    });

    useGeographic();
    this.map = new Map({
      controls: defaultControls().extend([new FullScreen()]),
      layers: [this.baseLayer, vectorLayer],
      target: this.element,
    });
    this.map.getView().fit(this.extent, this.map.getSize());
  }

  initializeCog() {
    const source = new GeoTIFF({
      sources: [{ url: this.urlValue }],
      convertToRGB: true,
    });

    source.getView().then((view) => {
      this.map = new Map({
        controls: defaultControls().extend([new FullScreen()]),
        target: this.element,
        layers: [
          this.baseLayer,
          new WebGLTileLayer({
            source,
          }),
        ],
        view: new View({
          center: view.center,
        }),
      });
      this.map.getView().fit(view.extent, this.map.getSize());
    });
  }
}
