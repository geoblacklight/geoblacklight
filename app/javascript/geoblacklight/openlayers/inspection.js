import { linkify } from "geoblacklight/leaflet/utils";

export const pmTilesInspection = (map) => {
  // add crosshair class for map items
  map.on('pointermove', function(e){
    var pixel = map.getEventPixel(e.originalEvent);
    var hit = map.hasFeatureAtPixel(pixel);
    map.getViewport().style.cursor = hit ? 'crosshair' : '';
  });

  map.on('click', (event) => {
    const spinner = document.createElement("tbody");
    spinner.className = "attribute-table-body";
    spinner.innerHTML =
      '<tr><td colspan="2"><div class="spinner-border" role="status"><span class="visually-hidden">Inspecting</span></div></td></tr>';
    document.querySelector(".attribute-table-body").replaceWith(spinner);

    const features = map.getFeaturesAtPixel(event.pixel);
    if (features.length == 0) {
      document.querySelector(".attribute-table-body").innerHTML =
        '<tr><td colspan="2">Could not find that feature</td></tr>';
      return;
    }

    const properties = features[0].getProperties();
    populateAttributeTable(properties);
  });
}

const populateAttributeTable = (properties) => {
  let html = '<tbody class="attribute-table-body">';

  // Step through properties and append to table
  Object.keys(properties).forEach((property) => {
    html += `<tr><td>${property}</td>
               <td>${linkify(properties[property])}</td></tr>`;
  });
  html += "</tbody>";

  const tableBody = document.querySelector(".attribute-table-body");
  if (tableBody) {
    tableBody.outerHTML = html; // Replace existing table body with new content
  }
}
