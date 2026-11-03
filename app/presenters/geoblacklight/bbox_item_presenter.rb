# frozen_string_literal: true

module Geoblacklight
  class BboxItemPresenter < Blacklight::FacetItemPresenter
    def value
      super.to_param
    end

    def label
      return super unless facet_item.is_a?(Geoblacklight::BoundingBox)

      facet_item.to_degrees_minutes
    end
  end
end
