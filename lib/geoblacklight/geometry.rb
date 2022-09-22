# frozen_string_literal: true

require "rgeo"
require "rgeo-geojson"

module Geoblacklight
  # Transforms and parses geometry expressed in WKT or CSW WKT ENVELOPE syntax
  class Geometry
    attr_reader :geom

    # @param [String] geom WKT or WKT ENVELOPE syntax formatted string
    def initialize(geom)
      @geom = geom
    end

    # Convert geometry to GeoJSON
    # @return [String]
    def geojson
      obj = factory.parse_wkt(geometry_as_wkt)
      RGeo::GeoJSON.encode(obj).to_json
    rescue
      Geoblacklight.logger.warn "Geometry is not valid: #{geom}"
      default_extent
    end

    # Generate a wsen bounding box from the geometry
    # @return [String] bounding box as comma delimited wsen "w, s, e, n"
    def bounding_box
      obj = factory.parse_wkt(geometry_as_wkt)

      # Get the minimum bounding box for the geometry as a Polygon
      bbox = obj.envelope

      # Return as wsen string
      minx = bbox.coordinates[0][0][0]
      miny = bbox.coordinates[0][0][1]
      maxx = bbox.coordinates[0][1][0]
      maxy = bbox.coordinates[0][2][1]
      "#{minx}, #{miny}, #{maxx}, #{maxy}"
    rescue RGeo::Error::ParseError
      Geoblacklight.logger.warn "Error parsing geometry: #{geom}"
      default_extent
    end

    private

    # Default extent as GeoJSON
    # @return [String]
    def default_extent
      {
        "type" => "Polygon",
        "coordinates" => [
          [
            [-180.0, 90.0], [-180.0, -90.0], [180.0, -90.0], [180.0, 90.0], [-180.0, 90.0]
          ]
        ]
      }.to_json
    end

    # Convert WKT ENVELOPE string to WKT POLYGON string
    # @return [String]
    def envelope_to_polygon
      exp = /^\s*ENVELOPE\(
                  \s*([-.\d]+)\s*,
                  \s*([-.\d]+)\s*,
                  \s*([-.\d]+)\s*,
                  \s*([-.\d]+)\s*
                  \)\s*$/x # uses 'x' option for free-spacing mode
      bbox_match = exp.match(geom)
      minx, maxx, maxy, miny = bbox_match.captures
      "POLYGON ((#{minx} #{maxy}, #{minx} #{miny}, #{maxx} #{miny}, #{maxx} #{maxy}, #{minx} #{maxy}))"
    end

    def factory
      @factory ||= RGeo::Cartesian.factory
    end

    # Return geometry as valid WKT string
    # @return [String]
    def geometry_as_wkt
      return geom unless geom.match?(/ENVELOPE/)

      envelope_to_polygon
    end
  end
end
