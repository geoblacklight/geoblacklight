module Geoblacklight
  module SolrDocument
    ##
    # Module to provide functions related to geometry
    module Geometry
      # Tries to infer geometry type from record and produce valid GeoJSON string
      def layer_geom_as_geojson
        geom_field = fetch(Settings.FIELDS.GEOMETRY, '')
        case geom_field
        when /^\s*ENVELOPE\(
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*
                  \)\s*$/x
          bbox_to_geojson(geom_field)
        when /^(POINT|POLYGON|LINESTRING|MULTIPOINT|MULTIPOLYGON|MULTILINESTRING)\s*\(.*\)$/x
          wkt_to_geojson(geom_field)
        else
          geom_field # and hope for the best...
        end
      end

      def wkt_to_geojson(wkt_string)
        JSON.generate(GeoRuby::SimpleFeatures::Polygon.from_ewkt(wkt_string).as_json)
      end

      def bbox_to_geojson(bbox_string)
        exp = /^\s*ENVELOPE\(
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*
                  \)\s*$/x # uses 'x' option for free-spacing mode
        bbox_match = exp.match(bbox_string)
        return bbox_string unless bbox_match # return as-is, not a WKT
        west, east, north, south = bbox_match.captures
        geometry = {
          type: 'Polygon',
          coordinates: [[[west, south], [west, north], [east, north], [east, south], [west, south]]]
        }
        JSON.generate(geometry)
      end

      def bounding_box_as_wsen
        geom_field = fetch(Settings.FIELDS.GEOMETRY, '')
        exp = /^\s*ENVELOPE\(
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*,
                  \s*([-\.\d]+)\s*
                  \)\s*$/x # uses 'x' option for free-spacing mode
        bbox_match = exp.match(geom_field)
        return geom_field unless bbox_match # return as-is, not a WKT
        w, e, n, s = bbox_match.captures
        "#{w} #{s} #{e} #{n}"
      end
    end
  end
end
