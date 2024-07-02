import L from "leaflet";
import { debounce, boundsToBbox } from "./utils";

export default class GeoSearch extends L.Control {
  constructor(options) {
    super(options);
    L.Util.setOptions(this, options);
  }

  onAdd(map) {
    const container = document.createElement("div");
    container.className = "leaflet-control search-control";
    container.appendChild(this.options.staticButton);
    container.appendChild(this.options.dynamicButton);

    this._map = map;

    const setButtons = () => {
      if (document.getElementById("gbl-static-button")) {
        this.staticButton = document.getElementById("gbl-static-button");
        this.dynamicButton = document.getElementById("gbl-dynamic-button");
        if (this.options.dynamic) {
          this.staticButton.style.display = "none";
          this.dynamicButton.style.display = "block";
        } else {
          this.staticButton.style.display = "block";
          this.dynamicButton.style.display = "none";
        }
      }
    };

    setButtons();

    const staticButtonExists = () => {
      if (
        typeof this.staticButton != "undefined" &&
        this.staticButton != null
      ) {
        return true;
      } else {
        return null;
      }
    };

    const staticSearcher = (e) => {
      setButtons();
      if (staticButtonExists() && e.target.id == "gbl-static-button") {
        this.staticButton.style.display = "none";
        if (this.options.dynamic) {
          this.dynamicButton.style.display = "block";
        }
        this.options.searcher.apply(this);
      }
    };

    const dynamicSearcher = debounce(() => {
      if (this.options.dynamic) {
        this.options.searcher.apply(this);
      }
    }, this.options.delay);

    document.addEventListener("click", staticSearcher);

    container.addEventListener("change", (e) => {
      if (e.target.type === "checkbox") {
        this.options.dynamic = !this.options.dynamic;
      }
    });

    if (this.options.dynamic) {
      setButtons();
      if (
        typeof this.staticButton != "undefined" &&
        this.staticButton != null
      ) {
        this.staticButton.style.display = "none";
        this.dynamicButton.style.display = "block";
      }
    } else {
      if (
        typeof this.dynamicButton != "undefined" &&
        this.dynamicButton != null
      ) {
        this.dynamicButton.style.display = "block";
        this.staticButton.style.display = "none";
      }
    }

    this.wasResized = false;
    map.on("resize", () => {
      this.wasResized = true;
    });

    map.on("moveend", () => {
      if (this.wasResized) {
        this.wasResized = false;
      } else {
        dynamicSearcher.apply(this);
      }
    });

    map.on("movestart", () => {
      if (!this.options.dynamic) {
        if (
          typeof this.dynamicButton != "undefined" &&
          this.dynamicButton != null
        ) {
          this.dynamicButton.style.display = "none";
          this.staticButton.style.display = "block";
        }
      }
    });

    return container;
  }

  getSearchUrl() {
    const params = this.filterParams(["bbox", "page"]),
      bounds = boundsToBbox(this._map.getBounds());

    params.push(`bbox=${encodeURIComponent(bounds.join(" "))}`);
    return `${this.options.baseUrl}?${params.join("&")}`;
  }

  filterParams(filterList) {
    const querystring = window.location.search.substr(1);
    let params = [];

    if (querystring !== "") {
      params = querystring.split("&").filter((value) => {
        const [key] = value.split("=");
        return !filterList.includes(key);
      });
    }
    return params;
  }
}
