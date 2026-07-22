# frozen_string_literal: true

module Geoblacklight
  # Renders the available metadata views for a document.
  class MetadataComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
      super()
    end

    private

    def first_metadata?(metadata)
      @document.references.shown_metadata.first.type == metadata.type
    end

    def render_transformed_metadata(metadata)
      content = metadata.transform.html_safe
      render partial: "catalog/metadata/content", locals: {content: content}
    rescue Geoblacklight::MetadataTransformer::TransformError => transform_err
      Geoblacklight.logger.warn transform_err.message
      render partial: "catalog/metadata/markup", locals: {content: metadata.to_xml}
    rescue Geoblacklight::MetadataTransformer::ParseError,
      Geoblacklight::MetadataTransformer::TypeError => err
      Geoblacklight.logger.warn err.message
      render partial: "catalog/metadata/missing"
    end
  end
end
