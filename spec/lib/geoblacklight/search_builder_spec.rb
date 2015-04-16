require 'spec_helper'

describe Geoblacklight::SearchBuilder do
  let(:method_chain) { CatalogController.search_params_logic }
  let(:user_params) { Hash.new }
  let(:solr_params) { Hash.new }
  let(:context) { CatalogController.new }

  let(:search_builder) { described_class.new(method_chain, context) }

  subject { search_builder.with(user_params) }

  describe '#initialize' do
    it 'should have add_spatial_params in processor chain once' do
      correct_processor_chain = [:default_solr_parameters,
                                 :add_query_to_solr,
                                 :add_facet_fq_to_solr,
                                 :add_facetting_to_solr,
                                 :add_solr_fields_to_query,
                                 :add_paging_to_solr,
                                 :add_sorting_to_solr,
                                 :add_group_config_to_solr,
                                 :add_range_limit_params,
                                 :add_spatial_params]
      expect(subject.processor_chain).to include :add_spatial_params
      expect(subject.processor_chain).to match_array correct_processor_chain
      new_search = described_class.new(subject.processor_chain, context)
      expect(new_search.processor_chain).to include :add_spatial_params
      expect(new_search.processor_chain).to match_array correct_processor_chain
    end
  end

  describe '#add_spatial_params' do
    it 'should return the solr_params when no bbox is given' do
      expect(subject.add_spatial_params(solr_params)).to eq solr_params
    end

    it 'should return a spatial search if bbox is given' do
      params = { :bbox => '123' }
      subject.with(params)
      expect(subject.add_spatial_params(solr_params)[:fq].to_s).to include("Intersects")
    end
  end
end

