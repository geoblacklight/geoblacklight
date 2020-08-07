# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::GeoblacklightHelperBehavior do
  let(:dummy_class) do
    Class.new.extend(described_class)
  end
  let(:presenter) { instance_double(MyPresenter, fake_name: 'druid:abc123') }

  before do
    class MyPresenter < Blacklight::ShowPresenter
      def fake_name; end
    end
  end

  describe '#geoblacklight_present' do
    before do
      expect(dummy_class).to receive(:presenter).and_return(presenter)
    end
    context 'as a Symbol' do
      it 'calls defined presenter class' do
        expect(dummy_class.geoblacklight_present(:fake_name)).to eq 'druid:abc123'
      end
    end
    context 'as a String' do
      it 'calls defined presenter class' do
        expect(dummy_class.geoblacklight_present('fake_name')).to eq 'druid:abc123'
      end
    end
  end
end
