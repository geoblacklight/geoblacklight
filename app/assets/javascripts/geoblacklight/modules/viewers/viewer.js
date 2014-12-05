 // base viewer
 modulejs.define('viewer/viewer', function() {
  function Viewer(el) {
    this.element = el;
    this.data = $(this.element).data();
  };
  return Viewer;
 });