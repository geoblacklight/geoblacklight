require 'spec_helper'

describe Geoblacklight::HglDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', layer_id_s: 'cite:harvard-test') }
  let(:download) { described_class.new(document, 'foo@example.com') }
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
end
