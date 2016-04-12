module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class DocumentPresenter < Blacklight::DocumentPresenter
    ##
    # Accesses a documents configured Wxs Identifier
    # @return [String]
    def wxs_identifier
      field = Settings.FIELDS.WXS_IDENTIFIER
      render_field_value(@document[field])
    end

    ##
    # Accesses a documents configured file formats
    # @return [String]
    def file_format
      field = Settings.FIELDS.FILE_FORMAT
      render_field_value(@document[field])
    end

    ##
    # Presents configured index fields in search results. Passes values through
    # configured helper_method. Multivalued fields separated by presenter
    # field_value_separator (default: comma). Fields separated by period.
    # @return [String]
    def index_fields_display
      fields_values = []
      @configuration.index_fields.each do |field_name, _|
        val = render_index_field_value(field_name)
        unless val.empty?
          val += '.' unless val.end_with?('.')
          fields_values << val
        end
      end
      fields_values.join(' ')
    end
  end
end
