require 'spec_helper'

describe Geoblacklight::KmzDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', solr_wfs_url: 'http://www.example.com/wfs', layer_id_s: 'stanford-test', solr_geom: 'ENVELOPE(-180, 180, 90, -90)') }
  let(:download) { described_class.new(document) }
  describe '#initialize' do
    it 'initializes as a KmzDownload object with specific options' do
      expect(download).to be_an described_class
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'application/vnd.google-earth.kmz'
      expect(options[:request_params][:layers]).to eq 'stanford-test'
      expect(options[:request_params][:bbox]).to eq '-180, -90, 180, 90'
    end
    it 'merges custom options' do
      download = described_class.new(document, timeout: 33)
      options = download.instance_variable_get(:@options)
      expect(options[:timeout]).to eq 33
    end
  end
end
