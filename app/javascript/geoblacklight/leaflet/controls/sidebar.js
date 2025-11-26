import { Control } from "leaflet";

export default class sidebarControl extends Control {
  constructor(options) {
    const _options = { ...options };
    super(_options);
  }

  onAdd(map) {
    var div = L.DomUtil.create('div', 'leaflet-sidebar');
    div.setAttribute("tabindex", "0");
    const sidebarContainer = this.options.sidebar;

    // Disable zoom when the mouse enters the sidebar
    div.addEventListener('mouseenter', function() {
      map.scrollWheelZoom.disable();
    });

    div.addEventListener('touchstart', function() {
      map.touchZoom.disable();
      map.dragging.disable();
    });

    // without this the map will try to find data about whatever is behind the sidebar
    div.addEventListener('click', function(event) {
      event.stopPropagation();
    });

    // Enable zoom when the mouse leaves the sidebar
    div.addEventListener('touchend', function() {
      map.touchZoom.enable();
      map.dragging.enable();
    });

    // Enable zoom when the mouse leaes the sidebar
    div.addEventListener('mouseleave', function() {
      map.scrollWheelZoom.enable();
    });

    if (!sidebarContainer) { return };
    // Make sure table height is same as map (with a little padding)
    sidebarContainer.children[0].style.maxHeight = `${map._container.offsetHeight - 30}px`;
    div.innerHTML = sidebarContainer.innerHTML;
    sidebarContainer.remove();
    return div;
  }
}