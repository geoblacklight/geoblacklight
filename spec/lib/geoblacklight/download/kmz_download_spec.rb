require 'spec_helper'

describe KmzDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', solr_wfs_url: 'http://www.example.com/wfs', layer_id_s: 'stanford-test', solr_rpt: '-180 -90 180 90') }
  let(:download) { KmzDownload.new(document) }
  describe '#initialize' do
    it 'should initialize as a KmzDownload object with specific options' do
      expect(download).to be_an KmzDownload
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'application/vnd.google-earth.kmz'
      expect(options[:request_params][:layers]).to eq 'stanford-test'
      expect(options[:request_params][:bbox]).to eq '-180, -90, 180, 90'
    end
  end
end
