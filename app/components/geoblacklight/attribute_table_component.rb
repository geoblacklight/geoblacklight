# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering attribute table
  #
  class AttributeTableComponent < ViewComponent::Base
    def initialize(show_attribute_table:, **)
      @show_attribute_table = show_attribute_table
      super
    end

    def render?
      @show_attribute_table
    end
  end
end
