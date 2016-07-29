require 'spec_helper'

describe CatalogController, type: :controller do
  describe '#web_services' do
    it 'returns a document based off an id' do
      get :web_services, params: { id: 'mit-us-ma-e25zcta5dct-2000' }
      expect(response.status).to eq 200
      expect(assigns(:document)).not_to be_nil
    end
  end
end
