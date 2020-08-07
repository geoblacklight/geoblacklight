# frozen_string_literal: true
require 'geo_combine'

module Geoblacklight
  module MetadataTransformer
    ##
    # Exceptions raised for the types of geospatial metadata
    class TypeError < EncodingError; end
    ##
    # Exceptions raised when parsing geospatial metadata in the XML
    class ParseError < EncodingError; end
    ##
    # Exception raised when the geospatial metadata content is empty
    class EmptyMetadataError < ParseError; end
    ##
    # Exceptions raised when transforming the metadata into the HTML
    class TransformError < EncodingError; end

    ##
    # Initialize a new MetadataTransformer instance
    # @param [Geoblacklight::Metadata::Base] metadata string or File path to the raw metadata
    # @return [Geoblacklight::MetadataTransformer::BaseTransformer]
    def self.instance(metadata)
      type = metadata.class.name.split('::').last
      begin
        klass = "Geoblacklight::MetadataTransformer::#{type.capitalize}".constantize
      rescue
        raise TypeError, "Metadata type #{type} is not supported"
      end

      klass.new(metadata)
    end
  end
end
