module Geoblacklight
  class References
    def initialize(document)
      @document = document
    end

    ##
    # All reference objects
    # @return [Array<Geoblacklight::Reference>]
    def refs
      @refs ||= metadata_refs + webservice_refs + download_refs
    end

    ##
    # Download reference objects
    # @return [Array<Geoblacklight::Reference>]
    def download_refs
      @download_refs ||= parse_references('downloads_sm').map { |ref| Reference.new(ref) }
    end

    ##
    # Metadata reference objects
    # @return [Array<Geoblacklight::Reference>]
    def metadata_refs
      @metadata_refs ||= parse_references('metadata_sm').map { |ref| Reference.new(ref) }
    end

    ##
    # Web service reference objects
    # @return [Array<Geoblacklight::Reference>]
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
    # @param [String, Symbol] ref_type
    # @return [Geoblacklight::Reference]
    def references(ref_type)
      refs.find { |reference| reference.type == ref_type }
    end

    ##
    # Available export formats pulled from each webservice
    # @return [Array]
    def available_export_formats
      webservice_refs.collect(&:export_formats).compact.flatten.uniq
    end

    ##
    # Hash of export formats and their connection urls
    # @return [Hash]
    def export_format_values
      {
        shapefile: wfs_endpoint,
        kmz: wms_endpoint,
        geojson: wfs_endpoint,
        geotiff: wms_endpoint
      }
    end

    def wms_endpoint
      return unless wms
      @wms_endpoint ||= wms.to_hash
    end

    def wfs_endpoint
      return unless wfs
      @wfs_endpoint ||= wfs.to_hash
    end

    ##
    # Generated download types
    # @return [Hash, nil]
    def download_types
      types = available_export_formats.map { |f| [f, export_format_values[f]] }
      types.to_h.compact
    end

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
      # Adds a call to references for defined types
      def method_missing(m, *_args, &_b)
        references m
      end
  end
end
