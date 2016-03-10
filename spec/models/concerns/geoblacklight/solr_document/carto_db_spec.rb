require 'spec_helper'

describe Geoblacklight::SolrDocument::CartoDb do
  let(:subject) { SolrDocument.new }
  let(:geojson_download) { instance_double(Geoblacklight::GeojsonDownload) }

  before do
    allow(Geoblacklight::GeojsonDownload).to receive(:new).and_return(geojson_download)
  end

  describe '#cartodb_reference' do
    it 'returns nil for restricted documents' do
      expect(subject).to receive(:public?).and_return(false)
      expect(subject.cartodb_reference).to be_nil
    end
    it 'returns nil for no download_types' do
      expect(subject).to receive(:public?).and_return(true)
      expect(subject).to receive(:download_types).and_return(nil)
      expect(subject.cartodb_reference).to be_nil
    end
    it 'returns nil with no :geojson download type' do
      expect(subject).to receive(:public?).and_return(true)
      expect(subject).to receive(:download_types).and_return(geotiff: 'geotiff')
      expect(subject.cartodb_reference).to be_nil
    end
    it 'Creates and returns a GeojsonDownload url' do
      expect(subject).to receive(:public?).and_return(true)
      expect(subject).to receive(:download_types)
        .and_return(geojson: { 'stuff' => 'stuff' })
      expect(geojson_download)
        .to receive(:url_with_params)
        .and_return('http://www.example.com/geojsonDownload')
      expect(subject.cartodb_reference).to eq 'http://www.example.com/geojsonDownload'
    end
  end
end
