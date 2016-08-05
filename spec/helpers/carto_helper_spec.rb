require 'spec_helper'

describe CartoHelper, type: :helper do
  describe '#carto_link' do
    let(:application_name) { 'My GeoBlacklight Deployment' }

    it 'removes spaces from application_name to produce valid Carto request URL' do
      expect(carto_link('http://demo.org/wfs/layer.json')).to eq 'http://oneclick.cartodb.com/?file=http%3A%2F%2Fdemo.org%2Fwfs%2Flayer.json&provider=MyGeoBlacklightDeployment&logo=http%3A%2F%2Fgeoblacklight.org%2Fimages%2Fgeoblacklight-logo.png'
    end
  end
end
