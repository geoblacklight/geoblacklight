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
  end
end
