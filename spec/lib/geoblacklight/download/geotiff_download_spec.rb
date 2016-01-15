require 'spec_helper'

describe Geoblacklight::GeotiffDownload do
  let(:document) { SolrDocument.new(layer_slug_s: 'test', layer_id_s: 'stanford-test', solr_geom: 'ENVELOPE(-180, 180, 90, -90)') }
  let(:download) { described_class.new(document) }
  describe '#initialize' do
    it 'initializes as a GeotiffDownload object with specific options' do
      expect(download).to be_an described_class
      options = download.instance_variable_get(:@options)
      expect(options[:content_type]).to eq 'image/geotiff'
      expect(options[:request_params][:layers]).to eq 'stanford-test'
      expect(options[:reflect]).to be_truthy
    end
    it 'merges custom options' do
      download = described_class.new(document, timeout: 33)
      options = download.instance_variable_get(:@options)
      expect(options[:timeout]).to eq 33
    end
  end
end
