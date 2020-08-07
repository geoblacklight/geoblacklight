# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::SpatialSearchBehavior do
  subject { search_builder.with(user_params) }

  let(:user_params) { {} }
  let(:solr_params) { {} }
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }
  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder).tap do |klass|
      include Blacklight::Solr::SearchBuilderBehavior
      klass.include(described_class)
    end
  end
  let(:search_builder) { search_builder_class.new(context) }

  describe '#add_spatial_params' do
    it 'returns the solr_params when no bbox is given' do
      expect(subject.add_spatial_params(solr_params)).to eq solr_params
    end

    context 'when given a bounding box' do
      let(:params) do
        { bbox: '-180 -80 120 80' }
      end

      before do
        subject.with(params)
      end

      it 'returns a spatial search if bbox is given' do
        expect(subject.add_spatial_params(solr_params)[:fq].to_s).to include('Intersects')
      end

      it 'applies boost based on configured Settings.BBOX_WITHIN_BOOST' do
        allow(Settings).to receive(:BBOX_WITHIN_BOOST).and_return 99
        expect(subject.add_spatial_params(solr_params)[:bq].to_s).to include('^99')
      end

      it 'applies default boost of 10 when Settings.BBOX_WITHIN_BOOST not configured' do
        allow(Settings).to receive(:BBOX_WITHIN_BOOST).and_return nil
        expect(subject.add_spatial_params(solr_params)[:bq].to_s).to include('^10')
      end

      it 'applies overlapRatio when Settings.OVERLAP_RATIO_BOOST is configured' do
        allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return 2
        expect(subject.add_spatial_params(solr_params)[:bf].to_s).to include('$overlap^2')
      end

      it 'does not apply overlapRatio when Settings.OVERLAP_RATIO_BOOST not configured' do
        allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return nil
        expect(subject.add_spatial_params(solr_params)).not_to have_key(:overlap)
      end

      context 'when local boost parameter is present' do
        before do
          solr_params[:bf] = ['local_boost^5']
        end

        it 'appends overlap and includes the local boost' do
          allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return 2
          expect(subject.add_spatial_params(solr_params)[:bf].to_s).to include('$overlap^2')
          expect(solr_params[:bf].to_s).to include('local_boost^5')
        end
      end

      context 'when the wrong format for the bounding box is used' do
        before do
          allow(subject).to receive(:bounding_box).and_raise(Geoblacklight::Exceptions::WrongBoundingBoxFormat)
        end

        it 'returns the spatial search without the boost or filter queries' do
          expect(subject.add_spatial_params(solr_params)).to eq(bq: [])
        end
      end
    end
  end
  describe '#envelope_bounds' do
    let(:bbox) { instance_double(Geoblacklight::BoundingBox) }
    before do
      allow(bbox).to receive(:to_envelope).and_return('test')
    end
    it 'calls to_envelope on the bounding box' do
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
