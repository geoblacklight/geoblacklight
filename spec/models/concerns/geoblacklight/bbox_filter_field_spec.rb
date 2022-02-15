# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Geoblacklight::BboxFilterField do
  let(:search_state) { Blacklight::SearchState.new(params.with_indifferent_access, blacklight_config, controller) }

  let(:params) { {} }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.add_facet_field 'bbox', filter_class: described_class
    end
  end
  let(:controller) { double }

  describe '#add' do
    context 'with a ordinary parameter' do
      it 'adds the parameter to the facets' do
        filter = search_state.filter('bbox')
        new_state = filter.add('140.143709 -65.487905 160.793791 86.107541')

        expect(new_state.params).to include bbox: '140.143709 -65.487905 160.793791 86.107541'
      end
    end

    context 'with a bounding box' do
      it 'adds the parameter to the bbox parameter' do
        filter = search_state.filter('bbox')
        new_state = filter.add(Geoblacklight::BoundingBox.from_rectangle('140.143709 -65.487905 160.793791 86.107541'))

        expect(new_state.params).to include bbox: '140.143709 -65.487905 160.793791 86.107541'
      end
    end
  end

  context 'with some existing data' do
    let(:params) { { bbox: '140.143709 -65.487905 160.793791 86.107541' } }

    describe '#add' do
      it 'replaces the existing range' do
        filter = search_state.filter('bbox')
        new_state = filter.add(Geoblacklight::BoundingBox.from_rectangle('100.143709 -70.487905 100.793791 96.107541'))

        expect(new_state.params).to include bbox: '100.143709 -70.487905 100.793791 96.107541'
      end
    end

    describe '#remove' do
      it 'removes the existing bbox' do
        filter = search_state.filter('bbox')
        new_state = filter.remove(Geoblacklight::BoundingBox.from_rectangle('140.143709 -65.487905 160.793791 86.107541'))

        expect(new_state.params[:bbox]).to be_nil
      end
    end

    describe '#values' do
      let(:params) { { bbox: '140.143709 -65.487905 160.793791 86.107541' } }

      it 'converts the parameters to a Geoblacklight::BoundingBox' do
        filter = search_state.filter('bbox')

        expect(filter.values.first).to be_a(Geoblacklight::BoundingBox).and(have_attributes(to_param: '140.143709 -65.487905 160.793791 86.107541'))
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
