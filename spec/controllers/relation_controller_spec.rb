require 'spec_helper'

describe RelationController, type: :controller do
  describe '#index' do
    it 'returns a listing of related documents for a record' do
      get :index, params: { id: 'nyu_2451_34502' }
      expect(response.status).to eq 200
      expect(assigns(:relations)).not_to be_nil
    end
  end
end
