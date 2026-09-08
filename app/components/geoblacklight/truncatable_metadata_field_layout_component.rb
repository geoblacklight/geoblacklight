# frozen_string_literal: true

module Geoblacklight
  # Lays out a metadata field so that it shows only the first few of its values, with a
  # button to reveal the rest. The label and the values are wrapped in a div so that
  # app/javascript/geoblacklight/initializers/field_truncation.js can tell which values
  # belong to the field; it reads the data attributes set here.
  #
  # Configure a show field to use it, optionally overriding the limit. Because this is a
  # layout rather than a field component, it composes with whatever component the field
  # already uses to render its values:
  #
  #   config.add_show_field field_config.subject, label: "Subject", link_to_facet: true,
  #     layout_component: Geoblacklight::TruncatableMetadataFieldLayoutComponent, limit: 3
  class TruncatableMetadataFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    DEFAULT_LIMIT = 5

    # @param read_more_text [String] label for the button that reveals the rest of the values
    # @param close_text [String] label for the button once the values are revealed
    # @param limit [Integer] number of values to show before hiding the rest
    def initialize(read_more_text: nil, close_text: nil, limit: nil, **kwargs)
      @read_more_text = read_more_text
      @close_text = close_text
      @limit = limit
      super(**kwargs)
    end

    private

    def truncate_data
      {
        read_more_text: @read_more_text || t("geoblacklight.truncate.read_more"),
        close_text: @close_text || t("geoblacklight.truncate.close"),
        button_label: t("geoblacklight.truncate.button_label"),
        limit: @limit || @field.field_config[:limit] || DEFAULT_LIMIT
      }
    end

    # A <dl> cannot hold a bare <button>, so the initializer moves the button into this
    # empty <dd>. It takes the same columns as the values so that it lines up with them.
    def read_more_slot_class
      ["read-more-slot", @offset_class, @value_class]
    end
  end
end
