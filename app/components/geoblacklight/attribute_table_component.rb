# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering attribute table
  #
  class AttributeTableComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
      super
    end

    def render?
      helpers.document_available?(@document) && @document.inspectable?
    end
  end
end
