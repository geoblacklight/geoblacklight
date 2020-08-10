# frozen_string_literal: true
require 'spec_helper'

describe ArcgisHelper, type: :helper do
  describe '#arcgis_link' do
    let(:application_name) { 'My GeoBlacklight Deployment' }

    it 'creates a valid ArcGIS online url with correct params' do
      expect(arcgis_link('http://example.com/foo/MapServer')).to eq 'https://www.arcgis.com/home/webmap/viewer.html?urls=http%3A%2F%2Fexample.com%2Ffoo%2FMapServer'
    end
    it 'handles multiple urls' do
      expect(arcgis_link(['http://example.com/foo/MapServer', 'http://example.com/foo/FeatureServer'])).to eq 'https://www.arcgis.com/home/webmap/viewer.html?urls=http%3A%2F%2Fexample.com%2Ffoo%2FMapServer&urls=http%3A%2F%2Fexample.com%2Ffoo%2FFeatureServer'
    end
  end
end
