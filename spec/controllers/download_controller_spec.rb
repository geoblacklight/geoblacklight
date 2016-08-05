require 'spec_helper'

describe Geoblacklight::DownloadController, type: :controller do
  describe '#file' do
    describe 'restricted file' do
      it 'redirects to login for authentication' do
        get :file, params: { id: 'stanford-cg357zz0321-shapefile', format: 'zip' }
        expect(response.status).to eq 401
      end
    end
    describe 'public file' do
      it 'initiates download' do
        allow(controller).to receive(:render) # Needed for testing with Rails 4
        expect(controller).to receive(:send_file)
        get :file, params: { id: 'mit-us-ma-e25zcta5dct-2000-shapefile', format: 'zip' }
      end
    end
  end
  describe '#show' do
    describe 'restricted file' do
      it 'redirects to login for authentication' do
        get :show, params: { id: 'stanford-cg357zz0321', format: 'json' }
        expect(response.status).to eq 401
      end
    end
    describe 'public file' do
      let(:shapefile_download) { instance_double(Geoblacklight::ShapefileDownload) }

      before do
        allow(Geoblacklight::ShapefileDownload).to receive(:new).and_return(shapefile_download)
      end

      it 'initiates download creation' do
        allow(shapefile_download).to receive(:get).and_return('success')
        get :show, params: { id: 'mit-us-ma-e25zcta5dct-2000', type: 'shapefile' }
        expect(response.status).to eq 200
      end
    end
  end
  describe '#hgl' do
    let(:hgl_download) { instance_double(Geoblacklight::HglDownload) }

    before do
      allow(Geoblacklight::HglDownload).to receive(:new).and_return(hgl_download)
    end

    it 'requests file' do
      allow(hgl_download).to receive(:get).and_return('success')
      get :hgl, params: { id: 'harvard-g7064-s2-1834-k3', email: 'foo@example.com' }
      expect(response.status).to eq 200
    end
    it 'renders form' do
      get :hgl, params: { id: 'harvard-g7064-s2-1834-k3' }
      expect(response).to render_template('hgl')
    end
  end
end
