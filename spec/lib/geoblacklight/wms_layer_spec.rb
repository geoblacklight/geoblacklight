require 'spec_helper'

describe WmsLayer do
  let(:params) { { 'URL' => 'http://www.example.com/', 'X' => '277' } }
  let(:wms_layer) { WmsLayer.new(params) }
  describe '#initialize' do
    it 'should initialize as a WmsLayer object' do
      expect(wms_layer).to be_an WmsLayer
    end
  end

  describe '#url' do
    it 'should return only URL parameter' do
      expect(wms_layer.url).to eq 'http://www.example.com/'
    end
  end

  describe '#search_params' do
    it 'should return all params except URL plus default params' do
      expect(wms_layer.search_params.length).to eq 8
      expect(wms_layer.search_params).to_not include 'URL' => 'http://www.example.com'
    end
  end

  describe '#request_response' do
    it 'should return a Faraday object' do
      faraday = double('faraday')
      allow(faraday).to receive(:get)
      expect(Faraday).to receive(:new).and_return(faraday)
      WmsLayer.new(params)
    end
  end
end
