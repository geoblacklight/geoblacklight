# frozen_string_literal: true

module Geoblacklight
  class WebServicesDefaultComponent < ViewComponent::Base
    attr_reader :reference
    def initialize(reference:)
      @reference = reference
      super
    end
  end
end
