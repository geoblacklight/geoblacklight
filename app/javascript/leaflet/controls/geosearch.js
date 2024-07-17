import { DomUtil, Control, Handler, setOptions } from "leaflet";
import { debounce, boundsToBbox } from "../utils";

export default class GeoSearchControl extends Control {
  constructor(options) {
    super(options);
    setOptions(this, options);
  }

  onAdd(map) {
    this.map = map;
    this.map.options.geoSearchControl = this;

    // Create the buttons
    this.staticButton = this.createStaticButton();
    this.dynamicButton = this.createDynamicButton();

    // Add the buttons to the viewer
    const container = DomUtil.create("div");
    container.className = "leaflet-control search-control";
    container.appendChild(this.staticButton);
    container.appendChild(this.dynamicButton);

    // Show the appropriate button
    if (this.options.dynamic) this.dynamicButton.style.display = "block";
    else this.staticButton.style.display = "block";

    // Set up the dynamic search function with debounce
    this.dynamicSearcher = debounce(() => {
      if (this.options.dynamic) {
        this.applySearch();
      }
    }, this.options.delay);

    // Add the event handler
    this.map.addHandler("geosearch", GeoSearchHandler);

    return container;
  }

  // Button to search when clicked; contains an icon
  createStaticButton() {
    const staticButtonNode = DomUtil.create("a");
    staticButtonNode.setAttribute("id", "gbl-static-button");
    staticButtonNode.setAttribute("href", "#");
    staticButtonNode.setAttribute("style", "display:none;");
    staticButtonNode.className = "btn btn-primary";
    staticButtonNode.textContent = "Redo search here";
    const span = DomUtil.create("span");
    span.className = "glyphicon glyphicon-repeat";
    staticButtonNode.appendChild(span);
    staticButtonNode.addEventListener("click", this.staticSearch.bind(this));
    return staticButtonNode;
  }

  // Button to search when the map is moved; contains a checkbox
  createDynamicButton() {
    const dynamicButtonNode = DomUtil.create("label");
    dynamicButtonNode.setAttribute("id", "gbl-dynamic-button");
    dynamicButtonNode.textContent = " Search when I move the map";
    dynamicButtonNode.setAttribute("style", "display:none;");
    const input = DomUtil.create("input");
    input.setAttribute("type", "checkbox");
    input.checked = true;
    dynamicButtonNode.insertBefore(input, dynamicButtonNode.firstChild);
    dynamicButtonNode.addEventListener(
      "input",
      this.toggleDynamicSearch.bind(this)
    );
    return dynamicButtonNode;
  }

  // Hide the static button, show the dynamic button, and apply the search
  staticSearch() {
    this.staticButton.style.display = "none";
    if (this.options.dynamic) {
      this.dynamicButton.style.display = "block";
    }
    this.applySearch();
  }

  // Update the URL with the current bounding box and go back to page 1
  applySearch() {
    const params = new URL(window.location).searchParams;
    params.delete("page");
    params.delete("bbox");
    const bbox = boundsToBbox(this._map.getBounds());
    // FIXME: we shouldn't pass the bbox with whitespace in it, but the catalog
    // controller won't honor it unless we do
    const url = `${this.options.baseUrl}?${params.toString()}&bbox=${bbox.join(
      " "
    )}`;
    window.location.href = url;
  }

  // Toggle the dynamic search option
  toggleDynamicSearch() {
    this.options.dynamic = !this.options.dynamic;
  }

  // Hide the dynamic button and show the static button
  hideDynamicButton() {
    this.dynamicButton.style.display = "none";
    this.staticButton.style.display = "block";
  }
}

class GeoSearchHandler extends Handler {
  constructor(map) {
    super(map);
    this.map = map;
    this.control = map.options.geoSearchControl;
    this.wasResized = false;
  }

  // Bind event handlers to the map
  addHooks() {
    this.map.on("resize", this.handleResize.bind(this));
    this.map.on("moveend", this.handleMoveEnd.bind(this));
    this.map.on("movestart", this.handleMoveStart.bind(this));
    console.log("added hooks");
  }

  // Remove event handlers from the map
  removeHooks() {
    this.map.off("resize");
    this.map.off("moveend");
    this.map.off("movestart");
    console.log("removed hooks");
  }

  handleResize() {
    console.log("resize");
    this.wasResized = true;
  }

  handleMoveEnd() {
    console.log("moveend");
    if (this.wasResized) this.wasResized = false;
    else this.control.dynamicSearcher.apply(this.control);
  }

  handleMoveStart() {
    console.log("movestart");
    if (!this.control.options.dynamic) {
      this.control.hideDynamicButton();
    }
  }
}
