require 'spec_helper'

describe Geoblacklight::WmsLayer do
  let(:params) { { 'URL' => 'http://www.example.com/', 'X' => '277' } }
  let(:wms_layer) { described_class.new(params) }
  describe '#initialize' do
    it 'initializes as a WmsLayer object' do
      expect(wms_layer).to be_an described_class
    end
  end

  describe '#url' do
    it 'returns only URL parameter' do
      expect(wms_layer.url).to eq 'http://www.example.com/'
    end
  end

  describe '#search_params' do
    it 'returns all params except URL plus default params' do
      expect(wms_layer.search_params.length).to eq 8
      expect(wms_layer.search_params).not_to include 'URL' => 'http://www.example.com'
    end
  end

  describe '#request_response' do
    it 'returns a Faraday object' do
      faraday = double('faraday')
      allow(faraday).to receive(:get)
      expect(Faraday).to receive(:new).and_return(faraday)
      described_class.new(params)
    end
  end
end
