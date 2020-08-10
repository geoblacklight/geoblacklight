# frozen_string_literal: true
module Geoblacklight
  module Metadata
    ##
    # Initialize a new Metadata instance
    # @param [Geoblacklight::Reference] reference the reference for the metadata resource
    # @return [Geoblacklight::Metadata::Base]
    def self.instance(reference)
      begin
        klass = "Geoblacklight::Metadata::#{reference.type.capitalize}".constantize
      rescue
        Geoblacklight.logger.warn "Metadata type #{reference.type} is not supported"
        klass = Geoblacklight::Metadata::Base
      end

      klass.new(reference)
    end
  end
end
