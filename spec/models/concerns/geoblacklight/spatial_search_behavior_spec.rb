require 'spec_helper'

describe Geoblacklight::SpatialSearchBehavior do
  let(:user_params) { Hash.new }
  let(:solr_params) { Hash.new }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }

  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder).tap do |klass|
      include Blacklight::Solr::SearchBuilderBehavior
      klass.include(described_class)
    end
  end

  let(:search_builder) { search_builder_class.new(context) }

  subject { search_builder.with(user_params) }

  describe '#add_spatial_params' do
    it 'returns the solr_params when no bbox is given' do
      expect(subject.add_spatial_params(solr_params)).to eq solr_params
    end

    it 'returns a spatial search if bbox is given' do
      params = { bbox: '-180 -80 120 80' }
      subject.with(params)
      expect(subject.add_spatial_params(solr_params)[:fq].to_s).to include('Intersects')
    end
  end
  describe '#envelope_bounds' do
    it 'calls to_envelope on the bounding box' do
      bbox = double('bbox', to_envelope: 'test')
      expect(subject).to receive(:bounding_box).and_return bbox
      expect(subject.envelope_bounds).to eq 'test'
    end
  end
  describe '#bounding_box' do
    it 'creates a bounding box from a Solr lat-lon rectangle format' do
      params = { bbox: '-120 -80 120 80' }
      subject.with(params)
      expect(subject.bounding_box).to be_an Geoblacklight::BoundingBox
    end
  end
end
