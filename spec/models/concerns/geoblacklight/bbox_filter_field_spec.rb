# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Geoblacklight::BboxFilterField do
  subject(:filter) { search_state.filter('bbox') }

  let(:bbox_value) { '140.143709 -65.487905 160.793791 86.107541' }
  let(:search_state) { Blacklight::SearchState.new(params.with_indifferent_access, blacklight_config, controller) }
  let(:params) { {} }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_facet_field 'bbox', filter_class: described_class
    end
  end
  let(:facet_config) { blacklight_config.facet_fields['bbox'] }
  let(:controller) { double }

  describe '#add' do
    context 'with a ordinary parameter' do
      it 'adds the parameter to the facets' do
        new_state = filter.add(bbox_value)

        expect(new_state.params).to include bbox: bbox_value
      end
    end

    context 'with a bounding box' do
      it 'adds the parameter to the bbox parameter' do
        new_state = filter.add(Geoblacklight::BoundingBox.from_rectangle(bbox_value))

        expect(new_state.params).to include bbox: bbox_value
      end
    end
  end

  context 'with some existing data' do
    let(:params) { { bbox: bbox_value } }

    describe '#add' do
      let(:bbox_replacement) { '100.143709 -70.487905 100.793791 96.107541' }
      it 'replaces the existing range' do
        new_state = filter.add(Geoblacklight::BoundingBox.from_rectangle(bbox_replacement))

        expect(new_state.params).to include bbox: bbox_replacement
      end
    end

    describe '#remove' do
      it 'removes the existing bbox' do
        new_state = filter.remove(Geoblacklight::BoundingBox.from_rectangle(bbox_value))

        expect(new_state.params[:bbox]).to be_nil
      end
    end

    describe '#values' do
      it 'converts the parameters to a Geoblacklight::BoundingBox' do
        expect(filter.values.first).to be_a(Geoblacklight::BoundingBox).and(have_attributes(to_param: bbox_value))
      end
    end

    describe '#needs_normalization?' do
      it 'returns false for the expected keyed representation of the bounding box' do
        expect(filter.needs_normalization?(search_state.params)).to be false
      end
    end

    context 'when array param represented by facebook as a Hash' do
      let(:filter) { described_class.new(facet_config, search_state) }
      let(:params) { { bbox: { '0' => bbox_value } } }

      describe '#normalize' do
        it 'converts the parameters to a list' do
          expect(filter.normalize(search_state.params[:bbox])).to eql [bbox_value]
        end
      end

      describe '#needs_normalization?' do
        it 'returns true for the hash-as-array keyed representation of the bounding box' do
          expect(filter.needs_normalization?(search_state.params[:bbox])).to be true
        end
      end
    end
  end

  context 'with a malformed bbox' do
    let(:params) { { bbox: 'totally-not-a-bbox' } }

    it 'excludes it from the values' do
      filter = search_state.filter('bbox')

      expect(filter.values).to be_empty
    end
  end
end
