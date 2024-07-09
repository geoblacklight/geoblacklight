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
  end
end
