# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Download do
  subject(:download) { described_class.new(document, options) }

  let(:faraday_connection) { instance_double(Faraday::Connection) }
  let(:faraday_response) { instance_double(Faraday::Response) }
  let(:references_field) { Settings.FIELDS.REFERENCES }
  let(:document) { SolrDocument.new(layer_slug_s: 'test', references_field => { 'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms' }.to_json) }
  let(:options) { { type: 'shapefile', extension: 'zip', service_type: 'wms', content_type: 'application/zip' } }

  describe '#initialize' do
    it 'initializes as a Download object' do
      expect(download).to be_a described_class
    end
  end

  describe '#downloadable?' do
    before do
      allow(document).to receive(:downloadable?).and_return(true)
    end
    it 'determines whether or not the resource can be downloaded' do
      expect(download.downloadable?).to be true
    end
  end

  describe '#file_name' do
    it 'gives the file name with path and extension' do
      expect(download.file_name).to eq 'test-shapefile.zip'
    end
  end
  describe '#file_path' do
    it 'returns the path with name and extension' do
      expect(download.class.file_path).to eq Rails.root.join('tmp', 'cache', 'downloads')
    end
    it 'is configurable' do
      expect(Settings).to receive(:DOWNLOAD_PATH).and_return('configured/path')
      expect(download.class.file_path).to eq 'configured/path'
    end
  end
  describe '#download_exists?' do
    it 'returns false if file does not exist' do
      expect(File).to receive(:file?).and_return(false)
      expect(download.download_exists?).to be_falsey
    end
    it 'returns true if file does not exist' do
      expect(File).to receive(:file?).and_return(true)
      expect(download.download_exists?).to be_truthy
    end
  end
  describe '#get' do
    before do
      allow(File).to receive(:file?).and_return(true)
    end

    it 'returns filename if download exists' do
      expect(download.get).to eq download.file_name
    end

    context 'when the file has not already been downloaded' do
      let(:connection) { instance_double(Faraday::Connection) }
      let(:response) { instance_double(Faraday::Response) }

      before do
        allow(File).to receive(:file?).and_return(false)
        allow(connection).to receive(:get).and_return(object: 'file')
        allow(Faraday).to receive(:new).and_return(connection)
      end

      it 'calls create_download_file if it does not exist' do
        allow(File).to receive(:open).with("#{download.file_path_and_name}.tmp", 'wb').and_return('')
        allow(File).to receive(:rename)

        expect(download.get).to eq 'test-shapefile.zip'
      end
    end
  end
  describe '#create_download_file' do
    let(:file) { instance_double(File) }
    let(:shapefile) { OpenStruct.new(headers: { 'content-type' => 'application/zip' }) }
    let(:connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response) }

    before do
      allow(file).to receive(:write)
      allow(Faraday).to receive(:new).and_return(connection)
      allow(connection).to receive(:get).and_return(shapefile)
    end

    it 'creates the file, write it, and then rename from tmp if everything is ok' do
      allow(File).to receive(:open).with("#{download.file_path_and_name}.tmp", 'wb').and_yield(file).and_return('')
      allow(File).to receive(:rename)

      expect(download.create_download_file).to eq download.file_name
    end

    context 'when the file received is not of the type requested' do
      let(:bad_file) { OpenStruct.new(headers: { 'content-type' => 'bad/file' }) }

      before do
        allow(connection).to receive(:get).and_return(bad_file)
      end

      it 'creates the file in fs and delete it if the content headers are not correct' do
        allow(File).to receive(:delete).with("#{download.file_path_and_name}.tmp").and_return(nil)

        expect { download.create_download_file }.to raise_error(Geoblacklight::Exceptions::ExternalDownloadFailed, 'Wrong download type')
      end
    end

    context 'when the MIME type has more information encoded' do
      let(:geojson) { OpenStruct.new(headers: { 'content-type' => 'application/json;charset=utf-8' }) }

      before do
        allow(connection).to receive(:get).and_return(geojson)
      end

      it 'accepts response MIME type that is more complex than requested' do
        allow(File).to receive(:open).with("#{download.file_path_and_name}.tmp", 'wb').and_return('')
        allow(File).to receive(:rename)

        expect(download.create_download_file).to eq download.file_name
      end
    end
  end
  describe '#initiate_download' do
    let(:faraday_request) { instance_double(Faraday::Request) }
    let(:faraday_request_options) { OpenStruct.new(timeout: nil, open_timeout: nil) }

    before do
      allow(faraday_request).to receive(:params=)
      allow(faraday_request).to receive(:options).and_return(faraday_request_options)
    end

    it 'request download from server' do
      allow(faraday_connection).to receive(:get).and_yield(faraday_request).and_return(faraday_response)
      allow(Faraday).to receive(:new).with(url: 'http://www.example.com/wms').and_return(faraday_connection)

      expect(download.initiate_download).to eq faraday_response
    end

    it 'raises Geoblacklight::Exceptions::ExternalDownloadFailed with a connection failure' do
      expect(faraday_connection).to receive(:url_prefix).and_return 'http://www.example.com/wms'
      expect(faraday_connection).to receive(:get).and_raise(Faraday::ConnectionFailed.new('Failed'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/wms').and_return(faraday_connection)
      expect { download.initiate_download }.to raise_error(Geoblacklight::Exceptions::ExternalDownloadFailed)
    end

    it 'raises Geoblacklight::Exceptions::ExternalDownloadFailed with a connection timout' do
      expect(faraday_connection).to receive(:url_prefix).and_return 'http://www.example.com/wms'
      expect(faraday_connection).to receive(:get).and_raise(Faraday::TimeoutError)
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/wms').and_return(faraday_connection)
      expect { download.initiate_download }.to raise_error(Geoblacklight::Exceptions::ExternalDownloadFailed)
    end
  end
  describe '#url_with_params' do
    let(:options) do
      {
        service_type: 'wms',
        request_params: {
          service: 'wfs',
          version: '2.0.0',
          request: 'GetFeature',
          srsName: 'EPSG:4326',
          outputformat: 'SHAPE-ZIP',
          typeName: ''
        }
      }
    end

    it 'creates a download url with params' do
      expect(download.url_with_params).to eq 'http://www.example.com/wms/?ser' \
        'vice=wfs&version=2.0.0&request=GetFeature&srsName=EPSG%3A4326&output' \
        'format=SHAPE-ZIP&typeName='
    end
  end
end
