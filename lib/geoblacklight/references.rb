# frozen_string_literal: true

module Geoblacklight
  # References is a geoblacklight-schema dct:references parser
  class References
    attr_reader :refs, :reference_field

    def initialize(document, reference_field = Geoblacklight.configuration.fields.references)
      @document = document
      @reference_field = reference_field
      @refs = parse_references.map { |ref| Reference.new(ref) }
    end

    ##
    # Return only those metadata references which are exposed within the configuration
    # @return [Geoblacklight::Reference]
    def shown_metadata_refs
      metadata_shown = Geoblacklight.configuration.metadata_shown
      metadata = @refs.select { |ref| metadata_shown.include?(ref.type.to_s) }
      metadata.sort do |u, v|
        metadata_shown.index(u.type.to_s) <=> metadata_shown.index(v.type.to_s)
      end
    end

    ##
    # Return only metadata for shown metadata
    # @return [Geoblacklight::Metadata::Base]
    def shown_metadata
      @shown_metadata ||= shown_metadata_refs.map { |ref| Geoblacklight::Metadata.instance(ref) }
    end

    ##
    # Accessor for a document's file format
    # @return [String] file format for the document
    def format
      @document.file_format
    end

    ##
    # @param [String, Symbol] ref_type
    # @return [Geoblacklight::Reference]
    def references(ref_type)
      @refs.find { |reference| reference.type == ref_type }
    end

    ##
    # Returns all of the Esri webservices for given set of references
    def esri_webservices
      %w[tiled_map_layer dynamic_map_layer feature_layer image_map_layer].filter_map do |layer_type|
        send(layer_type)
      end
    end

    private

    ##
    # Parses the references field of a document
    # @return [Hash]
    def parse_references
      if @document[reference_field].nil?
        {}
      else
        JSON.parse(@document[reference_field])
      end
    end

    ##
    # Adds a call to references for defined URI keys
    def method_missing(m, *args, &b)
      if Geoblacklight::Constants::URI.key?(m)
        references m
      else
        super
      end
    end

    def respond_to_missing?(m, *args, &b)
      Geoblacklight::Constants::URI.key?(m) || super
    end
  end
end
