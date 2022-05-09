# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Geoblacklight::BboxFilterQuery do
  # Subject
  subject(:bbox_filter_query) { described_class.new(filter, solr_params) }

  let(:solr_params) { {} }

  # Search State
  let(:search_state) { Blacklight::SearchState.new(params.with_indifferent_access, blacklight_config) }

  let(:params) do
    { bbox: '-180 -80 120 80' }
  end

  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_facet_field 'bbox', filter_class: Geoblacklight::BboxFilterField
    end
  end
  let(:facet_config) { blacklight_config.facet_fields['bbox'] }

  # Filter
  let(:filter) { Geoblacklight::BboxFilterField.new(facet_config, search_state) }

  describe '#initialize' do
    it 'initializes as a BboxFilterQuery object' do
      expect(bbox_filter_query).to be_a described_class
    end
  end

  describe '#envelope_bounds' do
    it 'returns an BoundingBox envelope' do
      expect(bbox_filter_query.envelope_bounds).to eq('ENVELOPE(-180, 120, 80, -80)')
    end
  end

  describe '#boost' do
    context 'without an explicit boost' do
      before do
        facet_config.within_boost = nil
      end

      it 'returns an default boost value' do
        expect(bbox_filter_query.boost).to eq('^10')
      end
    end

    context 'with an explicit boost' do
      before do
        facet_config.within_boost = 99
      end

      it 'applies boost based on configured Settings.BBOX_WITHIN_BOOST' do
        expect(bbox_filter_query.boost).to eq('^99')
      end
    end
  end

  describe '#relevancy_boost' do
    it 'returns a relevancy_boost' do
      expect(bbox_filter_query.relevancy_boost[:bq].to_s).to include('IsWithin')
    end

    context 'with overlap boost' do
      before do
        facet_config.overlap_boost = 2
      end

      it 'applies overlapRatio when Settings.OVERLAP_RATIO_BOOST is configured' do
        expect(bbox_filter_query.relevancy_boost[:bf].to_s).to include('$overlap^2')
      end
    end

    context 'without an overlap boost' do
      before do
        facet_config.overlap_boost = nil
      end

      it 'does not apply overlapRatio when Settings.OVERLAP_RATIO_BOOST not configured' do
        expect(bbox_filter_query.relevancy_boost).not_to have_key(:overlap)
      end
    end

    context 'when local boost parameter is present' do
      before do
        solr_params[:bf] = ['local_boost^5']
        facet_config.overlap_boost = 2
      end

      it 'appends overlap and includes the local boost' do
        expect(bbox_filter_query.relevancy_boost[:bf].to_s).to include('$overlap^2')
        expect(bbox_filter_query.relevancy_boost[:bf].to_s).to include('local_boost^5')
      end
    end
  end

  describe '#intersects_filter' do
    it 'returns an Intersects query' do
      expect(bbox_filter_query.intersects_filter).to include('Intersects')
    end
  end
end
