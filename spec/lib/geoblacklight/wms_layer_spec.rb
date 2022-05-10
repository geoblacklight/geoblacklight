# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::WmsLayer do
  let(:wms_layer) { described_class.new(params) }
  let(:rails_4_params) { { 'URL' => 'http://www.example.com/', 'X' => '277' } }
  let(:rails_5_params) { instance_double(ActionController::Parameters) }

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
    subject(:wms_layer) { described_class.new(params) }
    let(:params) { rails_4_params }
    let(:connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response) }

    before do
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it 'returns a Faraday object' do
      allow(connection).to receive(:get).and_return(response)
      expect(wms_layer.request_response).to eq(response)
    end

    context 'when the HTTP connection fails' do
      before do
        allow(Geoblacklight.logger).to receive(:error).with('#<Faraday::ConnectionFailed wrapped=#<StandardError: test connection error>>')
        allow(connection).to receive(:get).and_raise(Faraday::ConnectionFailed.new(StandardError.new('test connection error')))
      end

      it 'logs the Faraday error' do
        expect(Geoblacklight.logger).to receive(:error).exactly(3).times
        expect(wms_layer.request_response).to be_a Hash
        expect(wms_layer.request_response).to include(error: '#<Faraday::ConnectionFailed wrapped=#<StandardError: test connection error>>')
      end
    end

    context 'when the HTTP connection times out' do
      before do
        allow(Geoblacklight.logger).to receive(:error).with('#<Faraday::TimeoutError #<Faraday::TimeoutError: timeout>>')
        allow(connection).to receive(:get).and_raise(Faraday::TimeoutError)
      end

      it 'logs the Faraday error' do
        expect(Geoblacklight.logger).to receive(:error).exactly(3).times
        expect(wms_layer.request_response).to be_a Hash
        expect(wms_layer.request_response).to include(error: '#<Faraday::TimeoutError #<Faraday::TimeoutError: timeout>>')
      end
    end
  end
end
