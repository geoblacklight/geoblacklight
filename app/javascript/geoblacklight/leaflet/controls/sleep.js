import { DomUtil, DomEvent, Handler } from "leaflet";

export default class Sleep extends Handler {
  addHooks() {
    const container = DomUtil.create("div", "wake-overlay w-100 h-100 position-absolute align-items-center justify-content-center", this._map._container);
    const button = DomUtil.create("button", "btn btn-primary wake-button", container)

    button.innerHTML = this._map.options.MESSAGE;
    button.setAttribute("tabindex", "0");
    button.style.zIndex = 2000;
    container.style.zIndex = 1999;
    const background = String(this._map.options.BACKGROUND);
    container.style.background = background;
    this.container = container;
    if (this._map.options.MARGIN_DISTANCE) {
      this.updateBasedOnSize()
    } else {
      this.sleepMap();
    }
    this.setListeners()
  }

  sleepMap() {
    this._map.dragging.disable();
    this._map.touchZoom.disable();
    this._map.scrollWheelZoom.disable();
    this._map.doubleClickZoom.disable();
    this._map.boxZoom.disable();
    this._map.keyboard.disable();  
    this.container.classList.add('d-flex');
    this.container.classList.remove('d-none');
  }

  wakeMap() {
    this._map.dragging.enable();
    this._map.touchZoom.enable();
    this._map.scrollWheelZoom.enable();
    this._map.doubleClickZoom.enable();
    this._map.boxZoom.enable();
    this._map.keyboard.enable();
    this.container.classList.remove('d-flex');
    this.container.classList.add('d-none');
  }

  updateBasedOnSize() {
    const rect = this._map._container.getBoundingClientRect();
    // sometimes the left/right side has larger margin, so we take an average
    const calculation = ((window.innerWidth - rect.right) + rect.left) / 2;
    if (calculation < this._map.options.MARGIN_DISTANCE) {
      this.sleepMap();
    } else {
      this.wakeMap();
    }
  }

  setListeners() {
    const _this = this;
    let timer;
    let sleeptimer;

    if (_this._map.options.MARGIN_DISTANCE){
      window.addEventListener("resize", (event) => {
        console.log(event)
        _this.updateBasedOnSize();
      })
    }

    DomEvent.on(_this.container, "click", (e) => {
      _this.wakeMap()
    });

    DomEvent.on(_this.container, "focus", (e) => {
      _this.wakeMap()
    });

    if (this._map.options.HOVERTOWAKE) {
      DomEvent.on(this._map._container, "mouseenter", (e) => {
        clearTimeout(sleeptimer);

        timer = setTimeout(function() {
          _this.wakeMap()
        }, _this._map.options.WAKETIME);
      
      });

      DomEvent.on(this._map._container, "mouseleave", (e) => {
        clearTimeout(timer);
      
        sleeptimer = setTimeout(function() {
          _this.sleepMap()
        }, _this._map.options.SLEEPTIME);
      });
    }

    DomEvent.on(this.container, "touchstart", (e) => {
      _this.wakeMap()
    });
  }
}

