# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::SuppressedRecordsSearchBehavior do
  subject(:searcher) { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { { q: 'water' } }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder).tap do |klass|
      include Blacklight::Solr::SearchBuilderBehavior
      klass.include(described_class)
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  describe '#hide_suppressed_records' do
    it 'hides/filters suppressed records' do
      expect(searcher.hide_suppressed_records(solr_params)).to include('-suppressed_b: true')
    end
  end

  context 'when document action call like CatalogController#web_services' do
    it 'does not hide/filter suppressed records' do
      solr_params[:q] = "{!lucene}#{Settings.FIELDS.UNIQUE_KEY}:"
      expect(searcher.hide_suppressed_records(solr_params)).to be_nil
    end
  end
end
