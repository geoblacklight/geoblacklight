require 'spec_helper'

describe CatalogController, type: :controller do
  describe '#web_services' do
    it 'should return a document based off an id' do
      get :web_services, id: 'mit-us-ma-e25zcta5dct-2000'
      expect(response.status).to eq 200
      expect(assigns(:document)).to_not be_nil
    end
  end
end
