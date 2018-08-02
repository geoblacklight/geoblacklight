require 'spec_helper'

describe Geoblacklight::SolrDocument::Carto do
  let(:document) { MyDocument.new }
  let(:geojson_download) { instance_double(Geoblacklight::GeojsonDownload) }

  before do
    class MyDocument
      extend Blacklight::Solr::Document
      include Geoblacklight::SolrDocument::Carto
    end

    allow(Geoblacklight::GeojsonDownload).to receive(:new).and_return(geojson_download)
  end

  describe '#carto_reference' do
    it 'returns nil for restricted documents' do
      expect(document).to receive(:public?).and_return(false)
      expect(document.carto_reference).to be_nil
    end
    it 'returns nil for no download_types' do
      expect(document).to receive(:public?).and_return(true)
      expect(document).to receive(:download_types).and_return(nil)
      expect(document.carto_reference).to be_nil
    end
    it 'returns nil with no :geojson download type' do
      expect(document).to receive(:public?).and_return(true)
      expect(document).to receive(:download_types).and_return(geotiff: 'geotiff')
      expect(document.carto_reference).to be_nil
    end
    it 'Creates and returns a GeojsonDownload url' do
      expect(document).to receive(:public?).and_return(true)
      expect(document).to receive(:download_types)
        .and_return(geojson: { 'stuff' => 'stuff' })
      expect(geojson_download)
        .to receive(:url_with_params)
        .and_return('http://www.example.com/geojsonDownload')
      expect(document.carto_reference).to eq 'http://www.example.com/geojsonDownload'
    end
  end

  describe '#cartodb_reference' do
    before do
      allow(Deprecation).to receive(:warn).with(
        described_class,
        'cartodb_reference is deprecated and will be removed from Geoblacklight 2.0.0 (use Geoblacklight::SolrDocument::Carto#carto_reference instead)',
        kind_of(Array)
      )
      allow(document).to receive(:public?).and_return(true)
      allow(document).to receive(:download_types).and_return(geojson: { 'stuff' => 'stuff' })
      allow(geojson_download)
        .to receive(:url_with_params)
        .and_return('http://www.example.com/geojsonDownload')
    end

    it 'aliases to #carto_reference' do
      expect(Deprecation).to receive(:warn)
      expect(document.cartodb_reference).to eq(document.carto_reference)
    end
  end
end
