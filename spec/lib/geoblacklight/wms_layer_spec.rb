require 'spec_helper'

describe Geoblacklight::WmsLayer do
  let(:params) { { 'URL' => 'http://www.example.com/', 'X' => '277' } }
  let(:wms_layer) { Geoblacklight::WmsLayer.new(params) }
  describe '#initialize' do
    it 'initializes as a WmsLayer object' do
      expect(wms_layer).to be_an Geoblacklight::WmsLayer
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
      expect(wms_layer.search_params).to_not include 'URL' => 'http://www.example.com'
    end
  end

  describe '#request_response' do
    it 'returns a Faraday object' do
      faraday = double('faraday')
      allow(faraday).to receive(:get)
      expect(Faraday).to receive(:new).and_return(faraday)
      Geoblacklight::WmsLayer.new(params)
    end
  end
end
