# frozen_string_literal: true

module Geoblacklight
  class MetadataDescriptionMarkdownComponent < Blacklight::MetadataFieldComponent
    def render_field_values
      [tag.div(class: "truncate-abstract", data: {
        read_more_text: t("geoblacklight.truncate.read_more"),
        close_text: t("geoblacklight.truncate.close"),
        max_lines: 12
      }) do
        safe_join(Array(@field.values).flatten.map { |value| helpers.markdown_to_html(value) })
      end]
    end
  end
end
