# frozen_string_literal: true

module Geoblacklight
  class MetadataDescriptionMarkdownComponent < Blacklight::MetadataFieldComponent
    # Transform markdown into HTML
    # @param [String] value markdown to transform
    # @return [ActiveSupport::SafeBuffer] rendered HTML
    def markdown_to_html(value)
      Commonmarker.to_html(value).html_safe
    end

    def render_field_values
      [tag.div(class: "truncate-abstract", data: {
        read_more_text: t("geoblacklight.truncate.read_more"),
        close_text: t("geoblacklight.truncate.close")
      }) do
        safe_join(Array(@field.values).flatten.map { |value| markdown_to_html(value) })
      end]
    end
  end
end
