Blacklight.onLoad(function () {
    var historySupported = !!(window.history && window.history.pushState);

    if (historySupported) {
        History.Adapter.bind(window, 'statechange', function () {
            var state = History.getState();
            updatePage(state.url);
        });
    }

    $('[data-map="index"]').each(function () {
        var data = $(this).data(),
            opts = {baseUrl: data.catalogPath},
            geoblacklight;
        var geojson;

        if (typeof data.mapGeojson === 'string') { // Single, not array
            geojson = L.geoJson(data.mapGeojson).getBounds();
        } else {
            $('.document [data-geojson]').each(function () {
                var currentBbox = $(this).data().geojson;
                if (typeof currentBbox.coordinates == 'object') {
                    if (typeof geojson === 'undefined') {
                        geojson = L.geoJson($(this).data().geojson).getBounds();
                    } else {
                        geojson.extend(L.geoJson($(this).data().geojson).getBounds());
                    }
                }
            });
            if (typeof geojson == 'undefined') {
                geojson = L.geoJson({
                    "type": "Polygon",
                    "coordinates": [[[-195, -80], [-195, 80], [185, 80], [185, -80], [-195, -80]]]
                }).getBounds();
            }
        }

        if (!historySupported) {
            $.extend(opts, {
                dynamic: false,
                searcher: function () {
                    window.location.href = this.getSearchUrl();
                }
            });
        }

        // instantiate new map
        geoblacklight = new GeoBlacklight.Viewer.Map(this, {geojson: geojson});

        // set hover listeners on map
        $('#content')
            .on('mouseenter', '#documents [data-layer-id]', function () {
                var geojson = L.geoJson($(this).data('geojson'));
                geoblacklight.addGeoJsonOverlay(geojson);
            })
            .on('mouseleave', '#documents [data-layer-id]', function () {
                geoblacklight.removeBoundsOverlay();
            });

        // add geosearch control to map
        geoblacklight.map.addControl(L.control.geosearch(opts));
    });

    function updatePage(url) {
        $.get(url).done(function (data) {
            var resp = $.parseHTML(data);
            $doc = $(resp);
            $('#documents').replaceWith($doc.find('#documents'));
            $('#sidebar').replaceWith($doc.find('#sidebar'));
            $('#sortAndPerPage').replaceWith($doc.find('#sortAndPerPage'));
            $('#appliedParams').replaceWith($doc.find('#appliedParams'));
            if ($('#map').next().length) {
                $('#map').next().replaceWith($doc.find('#map').next());
            } else {
                $('#map').after($doc.find('#map').next());
            }
        });
    }

});
