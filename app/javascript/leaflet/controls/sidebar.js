import { Control } from "leaflet";

export default class sidebarControl extends Control {
  constructor(options) {
    const _options = { ...options };
    console.log(_options)
    super(_options);
  }

  onAdd(map) {
    var div = L.DomUtil.create('div', 'leaflet-sidebar');
    const tableHTML = document.querySelector('#table-html');
    console.log(tableHTML);
    if (!tableHTML) { return };
    div.innerHTML = tableHTML.innerHTML;
    tableHTML.remove();
    return div;
  }
}