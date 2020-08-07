# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::HglDownload do
  subject(:download) { described_class.new(document, options) }

  let(:document) { SolrDocument.new(layer_slug_s: 'test', layer_id_s: 'cite:harvard-test') }
  let(:options) { 'foo@example.com' }

  describe '#initialize' do
    it 'initializes as an HglDownload object with specific options' do
      expect(download).to be_an described_class
      options = download.instance_variable_get(:@options)
      expect(options[:request_params]['LayerName']).to eq 'harvard-test'
      expect(options[:request_params]['UserEmail']).to eq 'foo@example.com'
    end
    it 'merges custom options' do
      download = described_class.new(document, 'foo@example.com', timeout: 33)
      options = download.instance_variable_get(:@options)
      expect(options[:timeout]).to eq 33
    end
  end

  describe '#get' do
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:references_values) do
      {
        'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms'
      }
    end
    let(:options) do
      {
        service_type: 'wms',
        references_field => references_values.to_json
      }
    end
    let(:faraday_connection) { instance_double(Faraday::Connection) }
    let(:faraday_response) { instance_double(Faraday::Response) }
    let(:faraday_request) { instance_double(Faraday::Request) }
    let(:faraday_request_options) { OpenStruct.new(timeout: nil, open_timeout: nil) }
    let(:reference) { instance_double(Geoblacklight::Reference) }
    # Methods cannot be stubbed which are automatically generated from Hash keys
    let(:references) { double('references') }
    let(:endpoint) { 'http://www.example.com/wms' }

    before do
      allow(reference).to receive(:endpoint).and_return(endpoint)
      allow(references).to receive(:hgl).and_return(reference)
      allow(document).to receive(:references).and_return(references)
      allow(faraday_request).to receive(:params=)
      allow(faraday_request).to receive(:options).and_return(faraday_request_options)
    end

    it 'downloads the file and generates a message for the client' do
      allow(faraday_connection).to receive(:get).and_yield(faraday_request).and_return(faraday_response)
      allow(Faraday).to receive(:new).with(url: endpoint).and_return(faraday_connection)

      expect(download.get).to eq faraday_response
    end
  end
end
