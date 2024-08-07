import { Control } from "leaflet";

export default class sidebarControl extends Control {
  constructor(options) {
    const _options = { ...options };
    super(_options);
  }

  onAdd(map) {
    var div = L.DomUtil.create('div', 'leaflet-sidebar');
    div.setAttribute("tabindex", "0");
    const sidebarContainer = document.querySelector('#sidebar-html');

    // Disable zoom when the mouse enters the sidebar
    div.addEventListener('mouseenter', function() {
      map.scrollWheelZoom.disable();
    });

    // Enable zoom when the mouse enters the sidebar
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