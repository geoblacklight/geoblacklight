require 'spec_helper'

describe GeotiffDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', layer_id_s: 'stanford-test', solr_rpt: '-180 -90 180 90') }
  let(:download) { GeotiffDownload.new(document) }
  describe '#initialize' do
    it 'should initialize as a GeotiffDownload object with specific options' do
      expect(download).to be_an GeotiffDownload
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'image/geotiff'
      expect(options[:request_params][:layers]).to eq 'stanford-test'
      expect(options[:reflect]).to be_truthy
    end
  end
end
