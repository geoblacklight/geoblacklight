// Shortcuts
L.forNum = L.Util.formatNum;


// Plugin to create a search control
L.Control.searchControl = L.Control.extend({
  options: {
    position: 'topright'
  },
  onAdd: function(map) {
    var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
    this.link = L.DomUtil.create('a', 'leaflet-bar-part search-control', container);
    this.link.href = '#';
    this.icon = L.DomUtil.create('i', 'glyphicon glyphicon-search', this.link);
    L.DomEvent.on(this.link, 'click', this._click, this);
    return container;
  },
  intendedFunction: function() {
    console.log('def');
  },
  _click: function(e) {
    L.DomEvent.stopPropagation(e);
    L.DomEvent.preventDefault(e);
    this.intendedFunction();
  }
});

L.searchButton = function(btnFunction, btnMap) {
  var newControl = new L.Control.searchControl();
  newControl.intendedFunction = btnFunction;
  btnMap.addControl(newControl);
  return newControl;
};