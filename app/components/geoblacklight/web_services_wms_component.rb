# frozen_string_literal: true

module Geoblacklight
  class WebServicesWmsComponent < ViewComponent::Base
    attr_reader :reference, :document
    def initialize(reference:, document:)
      @reference = reference
      @document = document
      super
    end
  end
end
