module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class DocumentPresenter < Blacklight::DocumentPresenter
    ##
    # Accesses a documents configured Wxs Identifier
    # @param [SolrDocument]
    # @return [String]
    def wxs_identifier
      fields = Array(@configuration.wxs_identifier_field)
      f = fields.find { |field| @document.has? field }
      render_field_value(@document[f])
    end

    def file_format
      field = Settings.FIELDS.FILE_FORMAT.to_sym
      render_field_value(@document[field])
    end
  end
end
