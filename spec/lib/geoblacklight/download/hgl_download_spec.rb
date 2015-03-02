require 'spec_helper'

describe Geoblacklight::HglDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', layer_id_s: 'cite:harvard-test') }
  let(:download) { Geoblacklight::HglDownload.new(document, 'foo@example.com') }
  describe '#initialize' do
    it 'should initialize as an HglDownload object with specific options' do
      expect(download).to be_an Geoblacklight::HglDownload
      options = download.instance_variable_get(:@options)
      expect(options[:request_params]['LayerName']).to eq 'harvard-test'
      expect(options[:request_params]['UserEmail']).to eq 'foo@example.com'
    end
  end
end