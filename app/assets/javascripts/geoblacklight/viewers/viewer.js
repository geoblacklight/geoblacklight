// base viewer
GeoBlacklight.Viewer = L.Class.extend({
  options: {},

  initialize: function(el, options) {
    this.element = el;
    this.data = $(el).data();

    L.Util.setOptions(this, options);

    // trigger viewer load function
    this.load();
  }
});
