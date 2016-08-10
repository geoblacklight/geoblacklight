require 'spec_helper'

describe Geoblacklight::WmsLayer do
  let(:wms_layer) { described_class.new(params) }
  let(:rails_4_params) { { 'URL' => 'http://www.example.com/', 'X' => '277' } }
  let(:rails_5_params) { instance_double('ActionController::Parameters') }

  before do
    allow(rails_5_params).to receive(:to_h).and_return('URL' => 'http://www.example.com/', 'X' => '277')
  end

  describe '#initialize' do
    let(:params) { rails_4_params }

    it 'initializes as a WmsLayer object' do
      expect(wms_layer).to be_an described_class
    end
  end

  describe '#url' do
    context 'when running on rails 4' do
      let(:params) { rails_4_params }

      it 'returns the correct URL parameter' do
        expect(wms_layer.url).to eq('http://www.example.com/')
      end
    end

    context 'when running on rails 5' do
      let(:params) { rails_5_params }

      it 'returns the correct URL parameter' do
        expect(wms_layer.url).to eq('http://www.example.com/')
      end
    end
  end

  describe '#search_params' do
    context 'when running on rails 4' do
      let(:params) { rails_4_params }

      it 'returns all params except URL plus default params' do
        expect(wms_layer.search_params.length).to eq 8
        expect(wms_layer.search_params).not_to include 'URL' => 'http://www.example.com/'
      end
    end

    context 'when running on rails 5' do
      let(:params) { rails_5_params }

      it 'returns all params except URL plus default params' do
        expect(wms_layer.search_params.length).to eq 8
        expect(wms_layer.search_params).not_to include 'URL' => 'http://www.example.com/'
      end
    end
  end

  describe '#request_response' do
    let(:params) { rails_4_params }

    it 'returns a Faraday object' do
      faraday = double('faraday')
      allow(faraday).to receive(:get)
      expect(Faraday).to receive(:new).and_return(faraday)
      described_class.new(params)
    end
  end
end
