# frozen_string_literal: true

module Geoblacklight
  class AccordionComponent < ViewComponent::Base
    def initialize(id:, title:)
      @id = id
      @title = title
      super
    end
  end
end
