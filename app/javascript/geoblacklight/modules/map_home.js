import "./geosearch.js";
import GeoBlacklightViewerMap from "../viewers/map.js";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-map="home"]').forEach((element) => {
    const geoblacklight = new GeoBlacklightViewerMap(element);
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

    const geosearchOptions = {
      baseUrl: baseUrl,
      dynamic: false,
      searcher: function () {
        window.location.href = this.getSearchUrl();
      },
      staticButton: staticButtonNode,
      dynamicButton: dynamicButtonNode,
    };

    geosearchOptions.staticButton.href = "#";
    geosearchOptions.staticButton.className = "btn btn-primary";
    geosearchOptions.staticButton.textContent = "Search here";

    // Since L.control.geosearch might expect a string of HTML for the button, you might need to adjust the control
    // to accept DOM elements or modify the approach accordingly if it does not support DOM elements directly.
    geoblacklight.map.addControl(L.control.geosearch(geosearchOptions));
  });
});
