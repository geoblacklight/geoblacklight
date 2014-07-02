"use strict";

console.log('DEBUG: Inside geoblacklight/modules/map-view.js');
Blacklight.onLoad(function () {
  $('#geoblacklight-map-view').geoBlacklight_setupMapView();
  $('#geoblacklight-tools').geoBlacklight_setupTools();
});

/* Requires leaflet */
(function( $, document ) {
  var map, wmsLayer, spinner, mapBbox, alert, layerBbox;

  function WktBboxToJson(solrDoc){
    return [[solrDoc.solr_sw_pt_0_d, solrDoc.solr_sw_pt_1_d],
            [solrDoc.solr_ne_pt_0_d, solrDoc.solr_sw_pt_1_d],
            [solrDoc.solr_ne_pt_0_d, solrDoc.solr_ne_pt_1_d],
            [solrDoc.solr_sw_pt_0_d, solrDoc.solr_ne_pt_1_d]];
  }

  $.fn.geoBlacklight_setupMapView = function (options){
    return this.each(function () {
      console.log(this)
      map = L.map('map');
      console.log(solrDoc)
      // var layerBbox;
      // var location = JSON.parse(doc.Location);
      if (solrDoc.solr_bbox){
        layerBbox = WktBboxToJson(solrDoc);
        map.fitBounds([[solrDoc.solr_sw_pt_0_d, solrDoc.solr_sw_pt_1_d],
                       [solrDoc.solr_ne_pt_0_d, solrDoc.solr_ne_pt_1_d]]);
      }

      /* XXX: externalize configuration for Mapbox application key */
      var basemap = L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
        maxZoom: 18
      }).addTo(map);

      map.on('click', function(e){
        spinner = "<span id='attribute-table' class=''><i class='fa fa-spinner fa-spin fa-3x fa-align-center'></i></span>"
        $("#attribute-table").replaceWith(spinner);
        // console.log(e)
        mapBbox = map.getBounds()
        var wmsoptions = {
          "URL": solrDoc.solr_wms_url,
          "SERVICE": "WMS",
          "VERSION": "1.1.1",
          "REQUEST": "GetFeatureInfo",
          "LAYERS": solrDoc.layer_id_s,
          "STYLES": "",
          "SRS": "EPSG:4326", /* XXX: is this the correct projection? */
          "BBOX": mapBbox._southWest.lng + "," + mapBbox._southWest.lat + "," + mapBbox._northEast.lng + "," + mapBbox._northEast.lat,
          "WIDTH": $("#map").width(),
          "HEIGHT": $("#map").height(),
          "QUERY_LAYERS": solrDoc.layer_id_s,
          "X": Math.round(e.containerPoint.x),
          "Y": Math.round(e.containerPoint.y),
          "EXCEPTIONS": "application/json",
          "info_format": "application/json"
        }
        console.log(e);

        $.ajax({
          type: 'POST',
          url: '/wms/handle',
          data: wmsoptions,
          success: function(data){
            console.log(data)
            if ('gis_service' in data){
              console.log(data);
              return;
            }
            var t = $("<table id='attribute-table' class='table table-hover table-condensed table-responsive table-striped table-bordered'><thead><tr class=''><th>Attribute</th><th>Value</th></tr></thead><tbody>")
            $.each(data.values, function(i,val){
              t.append("<tr><td>" + val[0] + "</td><td>" + val[1] + "</tr>")
            });
            $('#attribute-table').replaceWith(t);
          },
          fail: function(error){
            console.log(error);
          }
        });
      });

      if (solrDoc.solr_wms_url && solrDoc.layer_id_s &&
          (solrDoc.dc_rights_s == 'Public' || solrDoc.dct_provenance_s == 'Stanford')){
        wmsLayer = L.tileLayer.wms(solrDoc.solr_wms_url, {
          layers: solrDoc.layer_id_s,
          format: 'image/png',
          transparent: true,  //so this seems to work for Stanford and Harvard
          tiled: true,
          CRS: "EPSG:900913",
          opacity: 0.75
        }).addTo(map);
      }else{
        L.polygon(layerBbox).addTo(map);
        $("#control").hide();
      }
      initHandle(wmsLayer);
      
    })

  }


  function initHandle(wmsLayer) {
    //MapBox Opacity Control
    var handle = document.getElementById('handle'),
      start = false,
      startTop;

    document.onmousemove = function(e) {
      if (!start) return;
      // Adjust control
      handle.style.top = Math.max(-5, Math.min(195, startTop + parseInt(e.clientY, 10) - start)) + 'px';
      // Adjust opacity
      wmsLayer.setOpacity(1 - (handle.offsetTop / 200));
    };

    if (handle) {
      handle.onmousedown = function(e) {
        // Record initial positions
        start = parseInt(e.clientY, 10);
        startTop = handle.offsetTop - 5;
        return false;
      };

    }

    document.onmouseup = function(e) {
      start = null;
    };

  }

})( jQuery, document );

(function ( $, document ) {
  $.fn.geoBlacklight_setupTools = function() {
    return this.each(function () {
      $(document).ready(function(){
        //See full abstract
        $('#more-abstract').on('click', function(){
          $('#abstract-trunc').toggle();
          $('#abstract-full').removeClass('hidden');
        });

        //Fire download shapefile REQUEST
        $('#download-shapefile').on('click', function(){
          $('#download-shapefile').addClass('disabled');
          $('#icon-shapefile').removeClass('fa-download');
          $('#icon-shapefile').addClass('fa-spinner fa-spin');
          $.ajax({
            type: 'POST',
            url: '/download/shapefile',
            data: solrDoc,
          }).done(function(data){
            var alert;
              $('#download-shapefile').removeClass('disabled');
              $('#icon-shapefile').removeClass('fa-spinner fa-spin');
              $('#icon-shapefile').addClass('fa-download');
              console.log(data);
              if ('error' in data){
                console.log('something bad');
                alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
              }else{
                alert = "<div class='alert alert-success fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Good to go!</strong> Your file is <a href='/download/file?q=" + data.data + "'>ready to download.</a></div>";
              }
              $("#main-flashes").append(alert);
          }).fail(function(data){
            alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
            $("#main-flashes").append(alert);
            $('#icon-shapefile').removeClass('fa-spinner fa-spin');
            $('#icon-shapefile').addClass('fa-download');

          });
        });

        $('#download-kml').on('click', function(){
          $('#download-kml').addClass('disabled');
          $('#icon-kml').removeClass('fa-download');
          $('#icon-kml').addClass('fa-spinner fa-spin');
          $.ajax({
            type: 'POST',
            url: '/download/kml',
            data: solrDoc,
          }).done(function(data){
              $('#download-kml').removeClass('disabled');
              $('#icon-kml').removeClass('fa-spinner fa-spin');
              $('#icon-kml').addClass('fa-download');
              console.log(data);
              if ('error' in data){
                console.log('something bad');
                alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
              }else{
                alert = "<div class='alert alert-success fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Good to go!</strong> Your file is <a href='/download/file?q=" + data.data + "'>ready to download.</a></div>";
              }
              $("#main-flashes").append(alert);
          }).fail(function(data){
            alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
            $("#main-flashes").append(alert);
            $('#icon-kml').removeClass('fa-spinner fa-spin');
            $('#icon-kml').addClass('fa-download');
          });
        });
      });
      
    })
  }
})( jQuery, document );
