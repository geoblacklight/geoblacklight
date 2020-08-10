# frozen_string_literal: true
module Geoblacklight
  module MetadataTransformer
    ##
    # Abstract class for transforming geospatial metadata
    class Base
      ##
      # @param [GeoCombine::Metadata] metadata metadata Object
      # @see GeoCombine::Metadata
      def initialize(metadata)
        @metadata = metadata
        # Access the Nokogiri::XML Document from the metadata Object
        fail EmptyMetadataError, 'Failed to retrieve the metadata' if @metadata.blank?
      end

      ##
      # Returns HTML for the metadata transformed into HTML using GeoCombine
      # @see GeoCombine::Metadata#to_html
      # @return [String] the transformed metadata in the HTML
      def transform
        cleaned_metadata.to_html
      rescue => e
        raise TransformError, e.message
      end

      private

      ##
      # Clean top-level HTML elements from GeoCombine HTML Documents (e. g. <html> and <body>)
      # @return [Nokogiri::XML::Document] the Nokogiri XML Document for the cleaned HTML
      def cleaned_metadata
        transformed_doc = Nokogiri::XML(@metadata.to_html)
        if transformed_doc.xpath('//body').children.empty?
          fail TransformError,\
               'Failed to extract the <body> child elements from the transformed metadata'
        end
        transformed_doc.xpath('//body').children
      rescue => e
        raise TransformError, e.message
      end
    end
  end
end
