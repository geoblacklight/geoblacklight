module Geoblacklight
  class References
    def initialize(document)
      @document = document
    end

    def refs
      metadata_refs + webservice_refs + download_refs
    end

    def download_refs
      @download_refs ||= parse_references('downloads_sm').map { |ref| Reference.new(ref) }
    end

    def metadata_refs
      @metadata_refs ||= parse_references('metadata_sm').map { |ref| Reference.new(ref) }
    end

    def webservice_refs
      @webservice_refs ||= parse_references('webservices_sm').map { |ref| Reference.new(ref) }
    end

    ##
    # Return only those metadata references which are exposed within the configuration
    # @return [Geoblacklight::Reference]
    def shown_metadata_refs
      metadata = metadata_refs.select { |ref| Settings.METADATA_SHOWN.include?(ref.type.to_s) }
      metadata.sort do |u, v|
        Settings.METADATA_SHOWN.index(u.type.to_s) <=> Settings.METADATA_SHOWN.index(v.type.to_s)
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
      @document[Settings.FIELDS.FILE_FORMAT]
    end

    ##
    # @param [String, Symbol] ref_type
    # @return [Geoblacklight::Reference]
    def references(ref_type)
      refs.find { |reference| reference.type == ref_type }
    end

    ##
    # Preferred download (should be a file download)
    # @return [Hash, nil]
    def preferred_download; end

    ##
    # Download hash based off of format type
    # @return [Hash, nil]
    def downloads_by_format; end

    ##
    # Generated download types from wxs services
    # @return (see #downloads_by_format)
    def download_types; end

    ##
    # Returns all of the Esri webservices for given set of references
    def esri_webservices
      %w[tiled_map_layer dynamic_map_layer feature_layer image_map_layer].map do |layer_type|
        send(layer_type)
      end.compact
    end

    private

      ##
      # Parses the references field of a document
      # @return [Hash]
      def parse_references(reference_field)
        if @document[reference_field].nil?
          []
        else
          @document[reference_field].collect { |r| JSON.parse(r) }
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
  end
end
