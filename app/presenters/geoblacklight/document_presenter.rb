# frozen_string_literal: true

module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  #
  # @deprecated This class is removed in GeoBlacklight 5. Applications that set
  #   `config.index.document_presenter_class = Geoblacklight::DocumentPresenter`
  #   in their CatalogController must drop that line, because the constant no
  #   longer exists.
  class DocumentPresenter < Blacklight::IndexPresenter
    include ActionView::Helpers::OutputSafetyHelper

    ##
    # Presents configured index fields in search results. Passes values through
    # configured helper_method. Multivalued fields separated by presenter
    # field_value_separator (default: comma). Fields separated by period.
    # @return [String]
    # @deprecated
    def index_fields_display
      fields_values = []
      @configuration.index_fields.each do |_field_name, field_config|
        val = field_value(field_config)
        if val.present?
          val += "." unless val.end_with?(".")
          fields_values << val
        end
      end
      safe_join(fields_values, " ")
    end
    Geoblacklight.deprecation.deprecate_methods(Geoblacklight::DocumentPresenter,
      index_fields_display: "use Geoblacklight::SearchResultComponent instead")
  end
end
