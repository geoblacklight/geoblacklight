# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Geoblacklight::HomepageFeatureFacetComponent, type: :component do
  subject(:rendered) do
    render_inline_to_capybara_node(described_class.new(**kargs))
  end

  # Build a search
  let(:context) { { whatever: :value } }
  let(:service) { Blacklight::SearchService.new(config: blacklight_config, user_params: user_params, **context) }
  let(:repository) { Blacklight::Solr::Repository.new(blacklight_config) }
  let(:user_params) { {} }
  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:copy_of_catalog_config) { ::CatalogController.blacklight_config.deep_copy }
  let(:blacklight_solr) { RSolr.connect(Blacklight.connection_config.except(:adapter)) }

  describe 'homepage' do
    before do
      (@response, @document_list) = service.search_results
    end

    let(:kargs) do
      {
        icon: 'home',
        label: 'geoblacklight.home.institution',
        facet_field: Settings.FIELDS.PROVENANCE,
        response: @response
      }
    end

    it 'includes facet links' do
      expect(rendered).to have_selector('div.category-block')
      expect(rendered).to have_selector('div.category-icon')
      expect(rendered).to have_selector('a.home-facet-link')
      expect(rendered).to have_selector('a.more_facets_link')
    end
  end
end
