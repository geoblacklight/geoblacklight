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
end
