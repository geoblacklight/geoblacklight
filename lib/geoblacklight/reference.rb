module Geoblacklight
  class Reference
    attr_reader :reference

    def initialize(reference)
      @reference = reference
    end

    def endpoint
      @reference[1]
    end

    def type
      Geoblacklight::Constants::URI.key(@reference[0])
    end

    def to_hash
      { type.to_sym => endpoint }
    end
  end
end
