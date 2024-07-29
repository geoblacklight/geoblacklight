# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering a single document
  #
  # @note when subclassing Blacklight::DocumentComponent, if you override the initializer,
  #    you must explicitly specify the counter variable `document_counter` even if you don't use it.
  #    Otherwise view_component will not provide the count value when calling the component.
  #
  class SearchResultComponent < Blacklight::DocumentComponent
    # Presents configured index fields in search results. Passes values through
    # configured helper_method. Multivalued fields separated by presenter
    # field_value_separator (default: comma). Fields separated by period.
    # @return [String]
    def index_fields_display
      fields_values = []
      @presenter.configuration.index_fields.each do |_field_name, field_config|
        val = @presenter.field_value(field_config).to_s
        if val.present?
          val += "." unless val.end_with?(".")
          fields_values << val
        end
      end
      safe_join(fields_values, " ")
    end
  end
end
