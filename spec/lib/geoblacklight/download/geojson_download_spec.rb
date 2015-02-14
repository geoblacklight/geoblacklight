require 'spec_helper'

describe GeojsonDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', solr_wfs_url: 'http://www.example.com/wfs', layer_id_s: 'stanford-test', solr_rpt: '-180 -90 180 90') }
  let(:download) { GeojsonDownload.new(document) }
  describe '#initialize' do
    it 'should initialize as a GeojsonDownload object with specific options' do
      expect(download).to be_an GeojsonDownload
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'application/json'
      expect(options[:request_params][:typeName]).to eq 'stanford-test'
    end
  end
end
