import { appendLoadingMessage, appendErrorMessage, linkify } from "./utils.js";
import { identifyFeatures } from "esri-leaflet";
import { getLayerOpacity } from "./utils";

export const wmsInspection = (map, url, layerId, layer) => {
  map.on("click", async (e) => {
    const spinner = document.createElement("tbody");
    spinner.className = "attribute-table-body";
    spinner.innerHTML =
      '<tr><td colspan="2"><div class="spinner-border" role="status"><span class="visually-hidden">Inspecting</span></div></td></tr>';
    document.querySelector(".attribute-table-body").replaceWith(spinner);

    const wmsoptions = {
      URL: url,
      LAYERS: layerId,
      BBOX: map.getBounds().toBBoxString(),
      WIDTH: Math.round(document.getElementById("leaflet-viewer").clientWidth),
      HEIGHT: Math.round(document.getElementById("leaflet-viewer").clientHeight),
      QUERY_LAYERS: layerId,
      X: Math.round(e.containerPoint.x),
      Y: Math.round(e.containerPoint.y),
    };

    try {
      const response = await fetch("/wms/handle", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
        body: JSON.stringify(wmsoptions),
      });

      if (!response.ok) throw new Error("Network response was not ok.");

      const response_data = await response.json();

      if (response_data.hasOwnProperty("error") || response_data.hasOwnProperty('exceptions') || response_data.features.length === 0) {
        document.querySelector(".attribute-table-body").innerHTML =
          '<tr><td colspan="2">Could not find that feature</td></tr>';
        return;
      }
      const data = response_data.features[0];
      if (!data.isHTML) overlayLayer(map, data, layer);

      populateAttributeTable(data);
    } catch (error) {
      console.error("Fetch error: ", error);
    }
  });
}

export const overlayLayer = (map, data, layer) => {
  const highlightLayerOld = Object.values(map._layers).filter(layer => layer.options.highlightLayer);
  if (highlightLayerOld[0]) highlightLayerOld.map(layer => map.removeLayer(layer));
  if (!data) return;

  let overlayLayer;

  const opacity = getLayerOpacity(layer);
  const color = map.options.selected_color;

  if (data._latlngs) {
    overlayLayer = L.polygon(data._latlngs, {color: color, weight: 2, layer: true, fillOpacity: opacity, addToOpacitySlider: true, highlightLayer: true });
  } else {
    overlayLayer = L.geoJSON(data, {
      color: color,
      opacity: opacity,
      addToOpacitySlider: true,
      highlightLayer: true,
      pointToLayer: function(feature, latlng) {
        return L.circleMarker(latlng, {
          radius: 8,
          fillColor: color,
          color: color,
          weight: 1,
          opacity: opacity,
          fillOpacity: opacity
        });
      }
    });
  }
  L.layerGroup([overlayLayer]).addTo(map);
}

export const tiledMapLayerInspection = (map, layer) => {
  this.map.on("click", (e) => {
    this.appendLoadingMessage();

    // Query layer at click location
    identifyFeatures({
      url: layer.options.url,
      useCors: true,
    })
      .tolerance(0)
      .returnGeometry(true)
      .on(map)
      .at(e.latlng)
      .run((error, featureCollection) => {
        if (error) {
          this.appendErrorMessage();
        } else {
          this.populateAttributeTable(featureCollection.features[0]);
        }
      });
  });
}

export const dynamicMapLayerInspection = (map, layer, layerId) => {
  map.on("click", (e) => {
    appendLoadingMessage();

    // Query layer at click location
    const identify = identifyFeatures({
      url: layer.options.url,
      useCors: true,
    })
      .tolerance(2)
      .returnGeometry(true)
      .on(map)
      .at(e.latlng);

    // Query specific layer if dynamicLayerId is set
    if (layerId) {
      identify.layers("all: " + layerId);
    }

    identify.run((error, featureCollection, response) => {
      if (error || response.results < 1) {
        appendErrorMessage();
      } else {
        overlayLayer(map, featureCollection.features[0], layer);
        populateAttributeTable(featureCollection.features[0]);
      }
    });
  });
}

export const featureLayerInspection = (map, layer) => {
  // Inspect on click
  layer.on("click", (e) => {
    const distance = 3000 / (1 + map.getZoom());

    appendLoadingMessage();

    // Query layer at click location
    layer
      .query()
      .returnGeometry(true)
      .nearby(e.latlng, distance)
      .run((error, featureCollection) => {
        if (error || !featureCollection.features.length) {
          appendErrorMessage();
        } else {
          overlayLayer(map, featureCollection.features[0], layer);
          populateAttributeTable(featureCollection.features[0]);
        }
      });
  });
}

const populateAttributeTable = (feature) => {
  let html = '<tbody class="attribute-table-body">';

  // Step through properties and append to table
  Object.keys(feature.properties).forEach((property) => {
    html += `<tr><td>${property}</td>
               <td>${linkify(feature.properties[property])}</td></tr>`;
  });
  html += "</tbody>";

  const tableBody = document.querySelector(".attribute-table-body");
  if (tableBody) {
    tableBody.outerHTML = html; // Replace existing table body with new content
  }
}
