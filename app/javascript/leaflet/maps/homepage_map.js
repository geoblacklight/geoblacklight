import GeoBlacklightViewerMap from "../viewers/map";
import GeoSearch from "../geosearch";

// Leaflet maps that displays on the homepage
export default class HomepageMap {
  constructor(element) {
    const geoBlacklight = new GeoBlacklightViewerMap(element);
    const data = element.dataset; // Assuming all data attributes are directly convertible

    const baseUrl = data.catalogPath; // Adjust according to actual data attributes

    // StaticButton
    // Create the anchor element
    const staticButtonNode = document.createElement("a");
    staticButtonNode.setAttribute("id", "gbl-static-button");
    staticButtonNode.setAttribute("href", "#");
    staticButtonNode.className = "btn btn-primary";
    staticButtonNode.textContent = "Search here ";

    // Create the span element for the glyphicon
    const span = document.createElement("span");
    span.className = "glyphicon glyphicon-repeat";

    // Append the span to the anchor element
    staticButtonNode.appendChild(span);

    // DynamicButton
    const dynamicButtonNode = document.createElement("label");
    dynamicButtonNode.setAttribute("id", "gbl-dynamic-button");
    dynamicButtonNode.textContent = " Search when I move the map";
    dynamicButtonNode.setAttribute("style", "display:none;");

    // Create the input (checkbox) element
    const input = document.createElement("input");
    input.setAttribute("type", "checkbox");
    input.checked = true; // Set the checkbox to be checked by default

    // Insert the input element at the beginning of the label element
    dynamicButtonNode.insertBefore(input, dynamicButtonNode.firstChild);

    const geoSearchOptions = {
      baseUrl: baseUrl,
      dynamic: false,
      searcher: function () {
        window.location.href = this.getSearchUrl();
      },
      staticButton: staticButtonNode,
      dynamicButton: dynamicButtonNode,
    };

    geoSearchOptions.staticButton.href = "#";
    geoSearchOptions.staticButton.className = "btn btn-primary";
    geoSearchOptions.staticButton.textContent = "Search here";

    geoBlacklight.map.addControl(new GeoSearch(geoSearchOptions));
  }
}
