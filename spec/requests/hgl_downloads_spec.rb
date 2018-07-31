require 'spec_helper'

describe 'HGL Downloads', type: :request do
  context 'with a successful request to the server' do
    it 'flashes a success message in response' do
      get '/download/hgl/harvard-g7064-s2-1834-k3?email=foo%40example.com'

      expect(response.body).to include('success')
      expect(response.body).to include('You should receive an email when your download is ready')
    end
  end
end
