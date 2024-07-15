import { wmsLayer, wmtsLayer } from "../../app/javascript/leaflet/layers";
import { describe, expect, it } from "vitest";

describe("leaflet/layers", () => {
  describe("wmsLayer", () => {
    it("returns a WMS tile layer", () => {
      const url = "http://example.com/wms";
      const layerId = "layerId";
      const opacity = 0.5;
      const detectRetina = true;
      const layer = wmsLayer(url, { layerId, opacity, detectRetina });
      expect(layer.options.layers).toEqual(layerId);
      expect(layer.options.opacity).toEqual(opacity);
      expect(layer.options.detectRetina).toEqual(detectRetina);
    });
  });
});
