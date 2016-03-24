module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class DocumentPresenter < Blacklight::DocumentPresenter
    ##
    # Accesses a documents configured Wxs Identifier
    # @return [String]
    def wxs_identifier
      field = Settings.FIELDS.WXS_IDENTIFIER.to_sym
      render_field_value(@document[field])
    end

    def file_format
      field = Settings.FIELDS.FILE_FORMAT.to_sym
      render_field_value(@document[field])
    end
  end
end
