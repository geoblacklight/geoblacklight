require 'spec_helper'

describe CartoHelper, type: :helper do
  describe '#carto_link' do
    let(:application_name) { 'My GeoBlacklight Deployment' }

    it 'removes spaces from application_name to produce valid Carto request URL' do
      expect(carto_link('http://demo.org/wfs/layer.json')).to eq 'http://oneclick.cartodb.com/?file=http%3A%2F%2Fdemo.org%2Fwfs%2Flayer.json&provider=MyGeoBlacklightDeployment&logo=http%3A%2F%2Fgeoblacklight.org%2Fimages%2Fgeoblacklight-logo.png'
    end

    context 'when the Settings.CARTODB_ONECLICK_LINK is set' do
      before do
        Settings.CARTODB_ONECLICK_LINK = true
        allow(Deprecation).to receive(:warn).with(
          GeoblacklightHelper,
          'Settings.CARTODB_ONECLICK_LINK is deprecated and will be removed in Geoblacklight 2.0.0, use Settings.CARTO_ONECLICK_LINK instead'
        )
      end

      it 'issues a deprecation warning' do
        expect(Deprecation).to receive(:warn)
        expect(carto_link('http://demo.org/wfs/layer.json')).to eq('http://oneclick.cartodb.com/?file=http%3A%2F%2Fdemo.org%2Fwfs%2Flayer.json&provider=MyGeoBlacklightDeployment&logo=http%3A%2F%2Fgeoblacklight.org%2Fimages%2Fgeoblacklight-logo.png')
      end

      after do
        Settings.CARTODB_ONECLICK_LINK = false
      end
    end
  end
end
