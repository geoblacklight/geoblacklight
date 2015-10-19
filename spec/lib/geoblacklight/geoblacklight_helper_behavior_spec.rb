require 'spec_helper'

describe Geoblacklight::GeoblacklightHelperBehavior do
  let(:dummy_class) do
    Class.new { include Geoblacklight::GeoblacklightHelperBehavior }.new
  end
  describe '#wxs_identifier' do
    it 'calls defined presenter class' do
      expect(dummy_class).to receive(:presenter)
        .and_return(double(wxs_identifier: 'druid:abc123'))
      expect(dummy_class.wxs_identifier).to eq 'druid:abc123'
    end
  end
  describe '#presenter_class' do
    it 'is defined as Geoblacklight::DocumentPresenter' do
      expect(dummy_class.presenter_class.new({}, {}, {}))
        .to be_a Geoblacklight::DocumentPresenter
    end
  end
end
