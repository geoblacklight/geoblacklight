import { appendLoadingMessage, appendErrorMessage, linkify } from "./utils.js";
import { identifyFeatures } from "esri-leaflet";

export const wmsInspection = (map, url, layerId) => {
  map.on("click", async (e) => {
    const spinner = document.createElement("tbody");
    spinner.className = "attribute-table-body";
    spinner.innerHTML =
      '<tr><td colspan="2"><div class="spinner-border" role="status"><span class="sr-only">Inspecting</span></div></td></tr>';
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

      const data = await response.json();

      if (data.hasOwnProperty("error") || data.values.length === 0) {
        document.querySelector(".attribute-table-body").innerHTML =
          '<tr><td colspan="2">Could not find that feature</td></tr>';
        return;
      }

      const html = document.createElement("tbody");
      html.className = "attribute-table-body";
      data.values.forEach((val) => {
        html.innerHTML += `<tr><td>${val[0]}</td><td>${val[1]}</td></tr>`; // Note: You might need to implement linkify functionality
      });
      document.querySelector(".attribute-table-body").replaceWith(html);
    } catch (error) {
      console.error("Fetch error: ", error);
    }
  });
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
      .returnGeometry(false)
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
      .returnGeometry(false)
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
      .returnGeometry(false)
      .nearby(e.latlng, distance)
      .run((error, featureCollection) => {
        if (error || !featureCollection.features.length) {
          appendErrorMessage();
        } else {
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