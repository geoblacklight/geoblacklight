module Geoblacklight
  ##
  # Parses an array of references to create useful reference information
  class Reference
    attr_reader :reference

    ##
    # Initializes a Reference object using an Array
    # @param [Hash] reference
    def initialize(reference)
      @reference = reference || {}
    end

    ##
    # The endpoint URL for a Geoblacklight::Reference
    # @return [String]
    def endpoint
      @reference['url']
    end

    ##
    # Label for the reference
    # @return [String]
    def label
      @reference['label']
    end

    ##
    # The layer id for a web service
    # @return [String]
    def layer_id
      @reference['layerId']
    end

    ##
    # Creates a hash, using its type as key and endpoint as value
    # @return [Hash]
    def to_hash
      { type => endpoint }
    end

    ##
    # Lookups the type from the Constants::URI using the reference's URI
    # @return [Symbol]
    def type
      @reference['type']&.parameterize&.underscore&.to_sym
    end
  end
end
