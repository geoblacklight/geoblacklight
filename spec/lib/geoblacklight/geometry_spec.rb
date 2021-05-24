# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Geometry do
  let(:wkt_geom) { 'MULTIPOLYGON(((-180 81.66, -180 -12.93, -168.35 -12.93, -168.35 81.66, -180 81.66)), ((180 81.66, 25 81.66, 25 -12.93, 180 -12.93, 180 81.66)))' }
  let(:envelope_geom) { 'ENVELOPE(25, -168.35, 81.66, -12.93)' }
  let(:invalid_geom) { 'INVALID' }
  let(:non_polygon_geom) { 'ENVELOPE(130, 130, 33, 33)' }

  describe '#geojson' do
    context 'with standard WKT geometry' do
      it 'returns geojson' do
        expect(described_class.new(wkt_geom).geojson).to include('MultiPolygon', 'coordinates', '[[[[-180.0,81.66]')
      end
    end

    context 'with envelope syntax geometry' do
      it 'returns geojson' do
        expect(described_class.new(envelope_geom).geojson).to include('Polygon', 'coordinates', '[[[25.0,81.66]')
      end
    end

    context 'with an invalid geometry' do
      it 'returns an empty string' do
        expect(described_class.new(invalid_geom).geojson).to eq ''
      end
    end

    context 'with a non-polygon geometry' do
      before do
        allow(RGeo::GeoJSON).to receive(:encode).and_raise(RGeo::Error::InvalidGeometry)
      end

      it 'returns an empty string' do
        expect(described_class.new(non_polygon_geom).geojson).to eq ''
      end
    end
  end

  describe '#bounding_box' do
    context 'with standard WKT geometry' do
      it 'returns a bounding_box' do
        expect(described_class.new(wkt_geom).bounding_box).to eq '-180.0, -12.93, 180.0, 81.66'
      end
    end

    context 'with envelope syntax geometry' do
      it 'returns a bounding_box' do
        expect(described_class.new(envelope_geom).bounding_box).to eq '-168.35, -12.93, 25.0, 81.66'
      end
    end

    context 'with an invalid geometry' do
      it 'returns an empty string' do
        expect(described_class.new(invalid_geom).bounding_box).to eq ''
      end
    end
  end
end
