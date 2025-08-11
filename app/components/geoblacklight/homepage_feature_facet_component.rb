# frozen_string_literal: true

module Geoblacklight
  class HomepageFeatureFacetComponent < ViewComponent::Base
    def initialize(icon:, label:, facet_field:, response:)
      @icon = icon
      @label = label
      @facet_field = facet_field
      @response = response
      super()
    end
  end
end
