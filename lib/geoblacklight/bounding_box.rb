# frozen_string_literal: true

module Geoblacklight
  ##
  # Transforms and parses a bounding box for various formats
  class BoundingBox
    ##
    # @param [String, Integer, Float] west
    # @param [String, Integer, Float] south
    # @param [String, Integer, Float] east
    # @param [String, Integer, Float] north
    def initialize(west, south, east, north)
      @west = west
      @south = south
      @east = east
      @north = north
      # TODO: check for valid Geometry and raise if not
    end

    ##
    # Returns a bounding box in ENVELOPE syntax
    # @return [String]
    def to_envelope
      "ENVELOPE(#{west}, #{east}, #{north}, #{south})"
    end

    def to_param
      "#{west} #{south} #{east} #{north}"
    end

    ##
    # Returns a human-readable version of the bounding box in degrees and
    # minutes, rounded to the nearest minute, e.g.
    # "18°58′W 10°01′N 25°07′E 40°00′N"
    # Falls back to the Solr rectangle syntax if a coordinate isn't numeric.
    # @return [String]
    def to_degrees_minutes
      coordinates = [west, south, east, north].map { |coordinate| Float(coordinate, exception: false) }
      return to_param if coordinates.any?(&:nil?)

      w, s, e, n = coordinates
      [
        degrees_minutes(w, "E", "W"),
        degrees_minutes(s, "N", "S"),
        degrees_minutes(e, "E", "W"),
        degrees_minutes(n, "N", "S")
      ].join(" ")
    end

    # Output a GeoJSON representation of the bounding box
    def to_geojson
      {
        "type" => "Polygon",
        "coordinates" => [
          [
            [west.to_f, south.to_f],
            [west.to_f, north.to_f],
            [east.to_f, north.to_f],
            [east.to_f, south.to_f],
            [west.to_f, south.to_f]
          ]
        ]
      }.to_json
    end

    ##
    # Create a Geoblacklight::BoundingBox from a Solr rectangle syntax
    # @param [String] bbox as "W S E N"
    # @return [Geoblacklight::BoundingBox]
    def self.from_rectangle(rectangle)
      rectangle_array = rectangle.is_a?(String) ? rectangle.split : []
      message = 'Bounding box should be a string in Solr rectangle syntax e.g."W S E N"'
      fail Geoblacklight::Exceptions::WrongBoundingBoxFormat, message if rectangle_array.count != 4
      new(
        rectangle_array[0],
        rectangle_array[1],
        rectangle_array[2],
        rectangle_array[3]
      )
    end

    private

    attr_reader :west, :south, :east, :north

    # Round to whole minutes before splitting so that e.g. 59.9′ carries
    # over into the degrees rather than showing as 60′.
    # A coordinate that rounds to zero gets no hemisphere.
    def degrees_minutes(degrees, positive, negative)
      total_minutes = (degrees.abs * 60).round
      degrees_part, minutes = total_minutes.divmod(60)
      hemisphere = degrees.negative? ? negative : positive
      hemisphere = "" if total_minutes.zero?

      format("%d°%02d′%s", degrees_part, minutes, hemisphere)
    end
  end
end
