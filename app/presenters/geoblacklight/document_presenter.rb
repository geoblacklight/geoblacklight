module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class DocumentPresenter < Blacklight::IndexPresenter
    ##
    # Presents configured index fields in search results. Passes values through
    # configured helper_method. Multivalued fields separated by presenter
    # field_value_separator (default: comma). Fields separated by period.
    # @return [String]
    def index_fields_display
      fields_values = []
      @configuration.index_fields.each do |field_name, _|
        val = field_value(field_name)
        unless val.blank?
          val += '.' unless val.end_with?('.')
          fields_values << val
        end
      end
      fields_values.join(' ')
    end
  end
end
