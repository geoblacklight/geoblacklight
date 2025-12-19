# frozen_string_literal: true

module Geoblacklight
  class HomepageFeatureFacetComponent < ViewComponent::Base
    def initialize(icon:, label:, facet_field:, response:)
      @icon = icon
      @label = label
      @facet_field = facet_field
      @items = response.aggregations[@facet_field].items

      super()
    end

    def facets
      links = @items.map do |item|
        link_to(item.value, search_catalog_path("f[#{@facet_field}][]": item.value), class: "home-facet-link")
      end
      links << link_to("more »", facet_catalog_path(@facet_field), class: "more_facets_link")
      safe_join(links, ", ")
    end
  end
end
