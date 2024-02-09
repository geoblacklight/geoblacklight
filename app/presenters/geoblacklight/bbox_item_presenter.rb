# frozen_string_literal: true

module Geoblacklight
  class BboxItemPresenter < Blacklight::FacetItemPresenter
    def value
      super.to_param
    end
  end
end
