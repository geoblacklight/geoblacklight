# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Reference do
  let(:typical_reference) do
    described_class.new(['http://www.opengis.net/def/serviceType/ogc/wms', 'http://hgl.harvard.edu:8080/geoserver/wms'])
  end
  let(:blank_reference) do
    described_class.new([])
  end
  describe '#initialize' do
    it 'instance variable reference is set' do
      expect(typical_reference.instance_variable_get(:@reference)).to eq ['http://www.opengis.net/def/serviceType/ogc/wms', 'http://hgl.harvard.edu:8080/geoserver/wms']
    end
  end
  describe '#endpoint' do
    it 'returns the endpoint url for a reference' do
      expect(typical_reference.endpoint).to eq 'http://hgl.harvard.edu:8080/geoserver/wms'
    end
    it 'returns nil for a blank reference' do
      expect(blank_reference.endpoint).to be_nil
    end
  end
  describe '#type' do
    it 'looks up a constant using the uri' do
      expect(typical_reference.type).to eq :wms
      expect(blank_reference.type).to be_nil
    end
  end
  describe '#to_hash' do
    it 'creates a hash using type and endpoint' do
      expect(typical_reference.to_hash).to eq wms: 'http://hgl.harvard.edu:8080/geoserver/wms'
    end
  end

  describe 'reference' do
    context 'key has one trailing slash' do
      let(:iso19139_reference) do
        described_class.new(['http://www.isotc211.org/schemas/2005/gmd/', 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/cg/357/zz/0321/iso19139.xml'])
      end

      it 'removes the trailing slash' do
        expect(iso19139_reference.send(:uri)).to eq 'http://www.isotc211.org/schemas/2005/gmd'
      end
    end
    context 'key does not have trailing slashes' do
      let(:iso19139_reference) do
        described_class.new(['http://www.isotc211.org/schemas/2005/gmd', 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.stanford.purl/master/cg/357/zz/0321/iso19139.xml'])
      end

      it 'will return the key' do
        expect(iso19139_reference.send(:uri)).to eq 'http://www.isotc211.org/schemas/2005/gmd'
      end
    end
    context 'key has trailing slashes' do
      let(:fgdc_reference) do
        described_class.new(['http://www.opengis.net/cat/csw/csdgm////', 'https://raw.githubusercontent.com/OpenGeoMetadata/edu.harvard/master/217/121/227/77/fgdc.xml'])
      end

      it 'removes the trailing slashes' do
        expect(fgdc_reference.send(:uri)).to eq 'http://www.opengis.net/cat/csw/csdgm'
      end
    end
  end
end
