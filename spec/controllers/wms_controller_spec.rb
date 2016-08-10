require 'spec_helper'

describe Geoblacklight::WmsController, type: :controller do
  let(:wms_layer) { instance_double('Geoblacklight::WmsLayer') }
  let(:feature_info) { { values: ['fid', 'layer:example'] } }
  let(:params) do
    { format: 'json', 'URL' => 'http://www.example.com/', 'LAYERS' => 'layer:example',
      'BBOX' => '-74, 40, -68, 43', 'WIDTH' => '500', 'HEIGHT' => '400',
      'QUERY_LAYERS' => 'layer:example', 'X' => '277', 'Y' => '195' }
  end

  before do
    allow(Geoblacklight::WmsLayer).to receive(:new).and_return(wms_layer)
    allow(wms_layer).to receive(:feature_info).and_return(feature_info)
  end

  describe '#handle' do
    it 'returns feature info as json' do
      get :handle, params: params
      expect(response.body).to eq(feature_info.to_json)
    end
  end

  describe '#wms_params' do
    let(:wms_params) { controller.instance_eval { wms_params } }

    it 'returns only permitted params' do
      get :handle, params: params
      expect(wms_params.to_h).not_to eq(params)
      params.delete(:format)
      expect(wms_params.to_h).to eq(params)
    end
  end
end
