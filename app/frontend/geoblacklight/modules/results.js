import './geosearch.js';
import GeoBlacklightViewerMap from '../viewers/map.js';

document.addEventListener('DOMContentLoaded', () => {
  const historySupported = !!(window.history && window.history.pushState);

  if (historySupported) {
    window.addEventListener('popstate', () => {
      const state = history.state;
      updatePage(state ? state.url : window.location.href);
    });
  }

  document.querySelectorAll('[data-map="index"]').forEach((element) => {
    const data = element.dataset,
          opts = { baseUrl: data.catalogPath },
          world = L.latLngBounds([[-90, -180], [90, 180]]);
    let geoblacklight, bbox;

    if (typeof data.mapGeom === 'string') {
      bbox = L.geoJSONToBounds(JSON.parse(data.mapGeom));
    } else {
      document.querySelectorAll('.document [data-geom]').forEach((docElement) => {
        try {
          const geomData = JSON.parse(docElement.dataset.geom);
          const currentBounds = L.geoJSONToBounds(geomData);
          if (!world.contains(currentBounds)) {
            throw new Error("Invalid bounds");
          }
          bbox = typeof bbox === 'undefined' ? currentBounds : bbox.extend(currentBounds);
        } catch (e) {
          bbox = L.bboxToBounds("-180 -90 180 90");
        }
      });
    }

    if (!historySupported) {
      Object.assign(opts, {
        dynamic: false,
        searcher: function() {
          window.location.href = this.getSearchUrl();
        }
      });
    }

    // instantiate new map
    geoblacklight = new GeoBlacklightViewerMap(element, { bbox });

    // add geosearch control to map

    // StaticButton
    // Create the anchor element
    const staticButtonNode = document.createElement('a');
    staticButtonNode.setAttribute('id', 'gbl-static-button');
    staticButtonNode.setAttribute('href', '#');
    staticButtonNode.setAttribute('style', 'display:none;');
    staticButtonNode.className = 'btn btn-primary';
    staticButtonNode.textContent = 'Redo search here';

    // Create the span element for the glyphicon
    const span = document.createElement('span');
    span.className = 'glyphicon glyphicon-repeat';

    // Append the span to the anchor element
    staticButtonNode.appendChild(span);

    // DynamicButton
    const dynamicButtonNode = document.createElement('label');
    dynamicButtonNode.setAttribute('id', 'gbl-dynamic-button');
    dynamicButtonNode.textContent = ' Search when I move the map';
    dynamicButtonNode.setAttribute('style', 'display:block;');

    // Create the input (checkbox) element
    const input = document.createElement('input');
    input.setAttribute('type', 'checkbox');
    input.checked = true; // Set the checkbox to be checked by default

    // Insert the input element at the beginning of the label element
    dynamicButtonNode.insertBefore(input, dynamicButtonNode.firstChild);

    const initialOptions = {
      dynamic: true,
      baseUrl: '',
      searcher: function() {
        window.location.href = this.getSearchUrl();
      },
      delay: 800,
      staticButton: staticButtonNode,
      dynamicButton: dynamicButtonNode
    };

    // set hover listeners on map
    document.getElementById('content').addEventListener('mouseenter', (event) => {
      const target = event.target.closest('[data-layer-id]');
      if(target && target.dataset.bbox !== "") {
        const geom = target.dataset.geom;
        geoblacklight.addGeoJsonOverlay(JSON.parse(geom));
      }
    }, true);

    document.getElementById('content').addEventListener('mouseleave', (event) => {
      const target = event.target.closest('[data-layer-id]');
      if(target) {
        geoblacklight.removeBoundsOverlay();
      }
    }, true);

    geoblacklight.map.addControl(L.control.geosearch(initialOptions));
  });

  function updatePage(url) {
    fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' }})
      .then(response => response.text())
      .then((html) => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');

        document.getElementById('documents').replaceWith(doc.querySelector('#documents'));
        document.getElementById('sidebar').replaceWith(doc.querySelector('#sidebar'));
        document.getElementById('sortAndPerPage').replaceWith(doc.querySelector('#sortAndPerPage'));
        document.getElementById('appliedParams').replaceWith(doc.querySelector('#appliedParams'));
        document.getElementById('pagination').replaceWith(doc.querySelector('#pagination'));
        const mapNextElement = document.getElementById('map').nextElementSibling;
        if (mapNextElement) {
          mapNextElement.replaceWith(doc.querySelector('#map').nextElementSibling);
        } else {
          document.getElementById('map').after(doc.querySelector('#map').nextElementSibling);
        }
      });
  }
});
