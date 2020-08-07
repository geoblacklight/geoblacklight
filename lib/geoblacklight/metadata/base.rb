# frozen_string_literal: true
module Geoblacklight
  module Metadata
    ##
    # Abstract Class for metadata
    class Base
      attr_reader :reference
      delegate :type, to: :reference
      delegate :to_html, to: :metadata
      delegate :transform, to: :transformer
      delegate :to_xml, to: :document

      ##
      # Instantiates a Geoblacklight::Metadata object used for retrieving and
      # formatting metadata
      # @param reference [Geoblacklight::Reference] the reference object
      def initialize(reference)
        @reference = reference
      end

      ##
      # Retrieves the XML Document for the metadata
      # @return [Nokogiri::XML::Document]
      def document
        @document ||= metadata.metadata
      end

      ##
      # Determines whether or not a metadata resources is empty
      # @return [Boolean]
      def blank?
        document.nil? || document.children.empty?
      end

      ##
      # Retrieves the URI for the reference resource (e. g. a service endpoint)
      # @return [String, nil]
      def endpoint
        blank? ? nil : @reference.endpoint
      end

      private

      ##
      # Retrieves metadata from a url source
      # @return [String, nil] metadata string or nil if there is a
      # connection error
      def retrieve_metadata
        connection = Faraday.new(url: @reference.endpoint) do |conn|
          conn.use FaradayMiddleware::FollowRedirects
          conn.adapter Faraday.default_adapter
        end
        begin
          response = connection.get
          return response.body unless response.nil? || response.status == 404
          Geoblacklight.logger.error "Could not reach #{@reference.endpoint}"
          ''
        rescue Faraday::ConnectionFailed => error
          Geoblacklight.logger.error error.inspect
          ''
        rescue Faraday::TimeoutError => error
          Geoblacklight.logger.error error.inspect
          ''
        rescue OpenSSL::SSL::SSLError => error
          Geoblacklight.logger.error error.inspect
          ''
        end
      end

      ##
      # Retrieve the Class for the GeoCombine data model
      # @return [GeoCombine::Metadata]
      def metadata_class
        GeoCombine::Metadata
      end

      ##
      # Handles metadata and returns the retrieved metadata or an error message if
      # something went wrong
      # @return [String] returned metadata string
      def metadata
        response_body = retrieve_metadata
        metadata_class.new(response_body)
      end

      ##
      # Initialize the MetadataTransformer Object for the metadata
      # @return [GeoBlacklight::MetadataTransformer] MetadataTransformer instance
      def transformer
        MetadataTransformer.instance(self)
      end
    end
  end
end
