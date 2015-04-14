require 'spec_helper'

describe Geoblacklight::Download do
  let(:response) { double('response') }
  let(:get) { double('get') }
  let(:body) { double('body') }
  let(:document) { SolrDocument.new(layer_slug_s: 'test', dct_references_s: {'http://www.opengis.net/def/serviceType/ogc/wms' => 'http://www.example.com/wms'}.to_json) }
  let(:options) { { type: 'shapefile', extension: 'zip', service_type: 'wms', content_type: 'application/zip' } }
  let(:download) { Geoblacklight::Download.new(document, options) }

  describe '#initialize' do
    it 'should initialize as a Download object' do
      expect(download).to be_an Geoblacklight::Download
    end
  end
  describe '#file_name' do
    it 'should give the file name with path and extension' do
      expect(download.file_name).to eq 'test-shapefile.zip'
    end
  end
  describe '#file_path' do
    it 'should return the path with name and extension' do
      expect(download.class.file_path).to eq "#{Rails.root}/tmp/cache/downloads"
    end
    it 'should be configurable' do
      expect(Settings).to receive(:DOWNLOAD_PATH).and_return('configured/path')
      expect(download.class.file_path).to eq 'configured/path'
    end
  end
  describe '#download_exists?' do
    it 'should return false if file does not exist' do
      expect(File).to receive(:file?).and_return(false)
      expect(download.download_exists?).to be_falsey
    end
    it 'should return true if file does not exist' do
      expect(File).to receive(:file?).and_return(true)
      expect(download.download_exists?).to be_truthy
    end
  end
  describe '#get' do
    it 'should return filename if download exists' do
      expect(download).to receive(:download_exists?).and_return(true)
      expect(download.get).to eq download.file_name
    end
    it 'should call create_download_file if it does not exist' do
      expect(download).to receive(:download_exists?).and_return(false)
      expect(download).to receive(:initiate_download).and_return(object: 'file')
      expect(File).to receive(:open).with("#{download.file_path_and_name}.tmp", 'wb').and_return('')
      expect(File).to receive(:rename)
      expect(download.get).to eq 'test-shapefile.zip'
    end
  end
  describe '#create_download_file' do
    it 'should create the file in fs and delete it if the content headers are not correct' do
      bad_file = OpenStruct.new(headers: { 'content-type' => 'bad/file' })
      expect(download).to receive(:initiate_download).and_return(bad_file)
      expect(File).to receive(:delete).with("#{download.file_path_and_name}.tmp").and_return(nil)
      expect { download.create_download_file }.to raise_error(Geoblacklight::Exceptions::ExternalDownloadFailed, 'Wrong download type')
    end
    it 'should create the file, write it, and then rename from tmp if everything is ok' do
      shapefile = OpenStruct.new(headers: {'content-type' => 'application/zip'})
      expect(download).to receive(:initiate_download).and_return(shapefile)
      expect(File).to receive(:open).with("#{download.file_path_and_name}.tmp", 'wb').and_return('')
      expect(File).to receive(:rename)
      expect(download.create_download_file).to eq download.file_name
    end
  end
  describe '#initiate_download' do
    it 'request download from server' do
      expect(response).to receive(:get).and_return(get)
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/wms').and_return(response)
      download.initiate_download
    end
    it 'should raise Geoblacklight::Exceptions::ExternalDownloadFailed with a connection failure' do
      expect(response).to receive(:url_prefix).and_return 'http://www.example.com/wms'
      expect(response).to receive(:get).and_raise(Faraday::Error::ConnectionFailed.new('Failed'))
      expect(Faraday).to receive(:new).with(url: 'http://www.example.com/wms').and_return(response)
      expect { download.initiate_download }.to raise_error(Geoblacklight::Exceptions::ExternalDownloadFailed)
    end
  end
end
