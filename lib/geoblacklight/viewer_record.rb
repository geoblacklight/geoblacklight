# frozen_string_literal: true

module Geoblacklight
  # A record as the item viewer is allowed to see it
  class ViewerRecord
    # These references aren't previewable data, so we don't need to restrict them
    METADATA_REFERENCES = %i[mods fgdc iso19139 html url data_dictionary].freeze

    # @param document [SolrDocument] the record as indexed
    # @param available [Boolean] see the document_available? helper
    def initialize(document, available:)
      @document = document
      @available = available
    end

    # If the record is available (public, or restricted and we're authed), return
    # as-is; otherwise strip out references that are previewable data
    # @return [Hash]
    def as_json(options = nil)
      record = @document.as_json(options)
      return record if @available || !record.key?(reference_field)

      record.merge(reference_field => metadata_references.to_json)
    end

    private

    def reference_field
      @document.references.reference_field.to_s
    end

    # The references we're keeping
    def metadata_references
      @document.references.refs
        .select { |reference| METADATA_REFERENCES.include?(reference.type) }
        .to_h { |reference| reference.reference }
    end
  end
end
