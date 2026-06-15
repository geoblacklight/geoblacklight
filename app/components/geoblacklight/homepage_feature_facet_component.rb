# frozen_string_literal: true

module Geoblacklight
  class HomepageFeatureFacetComponent < ViewComponent::Base
    def initialize(icon:, label:, facet_field_presenter:, items:)
      @icon = icon
      @label = label
      @facet_field_presenter = facet_field_presenter
      @items = items
      super()
    end

    def facets
      links = @items.map do |item|
        item_presenter = @facet_field_presenter.item_presenter(item)
        link_to(item_presenter.value, item_presenter.href, class: "home-facet-link")
      end
      links << link_to("more »", facet_catalog_path(@facet_field_presenter.key), class: "more_facets_link")
      safe_join(links, ", ")
    end
  end
end
