require 'spec_helper'

describe Geoblacklight::SearchBuilder do
  let(:method_chain) { CatalogController.search_params_logic }
  let(:user_params) { Hash.new }
  let(:solr_params) { Hash.new }
  let(:context) { CatalogController.new }

  let(:search_builder) { described_class.new(method_chain, context) }

  subject { search_builder.with(user_params) }

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

