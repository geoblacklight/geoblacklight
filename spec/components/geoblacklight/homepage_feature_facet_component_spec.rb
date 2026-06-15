# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::HomepageFeatureFacetComponent, type: :component do
  # Build a search
  let(:service) { Blacklight::SearchService.new(config: blacklight_config, search_state:) }
  let(:search_state) { Blacklight::SearchState.new({}, blacklight_config) }
  let(:blacklight_config) { ::CatalogController.blacklight_config.deep_copy }
  let(:facet_field) { Geoblacklight.configuration.fields.provider }
  let(:facet_config) { blacklight_config.facet_fields[facet_field] }
  let(:facet_field_presenter) { Blacklight::FacetFieldPresenter.new(facet_config, nil, vc_test_controller.view_context, nil) }
  let(:response) { service.search_results }
  let(:items) { response.aggregations[facet_field].items }

  subject(:instance) do
    described_class.new(
      icon: "home",
      label: "geoblacklight.home.institution",
      facet_field_presenter: facet_field_presenter,
      items: items
    )
  end

  it "includes facet links" do
    render_inline(instance)
    expect(page).to have_selector("div.category-block")
    expect(page).to have_selector("div.category-icon")
    expect(page).to have_selector("a.home-facet-link")
    expect(page).to have_selector("a.more_facets_link")
  end
end
