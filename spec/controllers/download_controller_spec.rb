require 'spec_helper'

describe Geoblacklight::DownloadController, type: :controller do
  describe '#file' do
    describe 'restricted file' do
      it 'should redirect to login for authentication' do
        get :file, id: 'stanford-jf841ys4828-shapefile', format: 'zip'
        expect(response.status).to eq 401
      end
    end
    describe 'public file' do
      it 'should initiate download' do
        expect(controller).to receive(:render)
        expect(controller).to receive(:send_file)
        get :file, id: 'mit-us-ma-e25zcta5dct-2000-shapefile', format: 'zip'
        expect(response.status).to eq 200
      end
    end
  end
  describe '#show' do
    describe 'restricted file' do
      it 'should redirect to login for authentication' do
        get 'show', id: 'stanford-jf841ys4828', format: 'json'
        expect(response.status).to eq 401
      end
    end
    describe 'public file' do
      it 'should initiate download creation' do
        get 'show', id: 'mit-us-ma-e25zcta5dct-2000'
        expect(response.status).to eq 200
      end
    end
  end
end