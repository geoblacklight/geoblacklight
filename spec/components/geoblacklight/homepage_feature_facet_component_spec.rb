# frozen_string_literal: true

require "spec_helper"

RSpec.describe Geoblacklight::HomepageFeatureFacetComponent, type: :component do
  # Build a search
  let(:context) { {whatever: :value} }
  let(:service) { Blacklight::SearchService.new(config: blacklight_config, search_state:, **context) }
  let(:repository) { Blacklight::Solr::Repository.new(blacklight_config) }
  let(:search_state) { Blacklight::SearchState.new({}, blacklight_config) }
  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:copy_of_catalog_config) { ::CatalogController.blacklight_config.deep_copy }
  let(:blacklight_solr) { RSolr.connect(Blacklight.connection_config.except(:adapter)) }

  describe "homepage" do
    before do
      (@response, @document_list) = service.search_results
    end

    let(:kargs) do
      {
        icon: "home",
        label: "geoblacklight.home.institution",
        facet_field: Geoblacklight.configuration.fields.provider,
        response: @response
      }
    end

    it "includes facet links" do
      render_inline(described_class.new(**kargs))
      expect(page).to have_selector("div.category-block")
      expect(page).to have_selector("div.category-icon")
      expect(page).to have_selector("a.home-facet-link")
      expect(page).to have_selector("a.more_facets_link")
    end
  end
end
