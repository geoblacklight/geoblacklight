require 'spec_helper'

describe Geoblacklight::GeojsonDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', solr_wfs_url: 'http://www.example.com/wfs', layer_id_s: 'stanford-test', solr_geom: 'ENVELOPE(-180, 180, 90, -90)') }
  let(:download) { Geoblacklight::GeojsonDownload.new(document) }
  describe '#initialize' do
    it 'should initialize as a GeojsonDownload object with specific options' do
      expect(download).to be_an Geoblacklight::GeojsonDownload
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'application/json'
      expect(options[:request_params][:typeName]).to eq 'stanford-test'
    end
  end
end
