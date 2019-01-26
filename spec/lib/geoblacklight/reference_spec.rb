require 'spec_helper'

describe Geoblacklight::Reference do
  let(:typical_reference) do
    described_class.new(
      'type': 'wms',
      'url': 'http://geoserver01.uit.tufts.edu/wms',
      'layerId': 'sde:GISPORTAL.GISOWNER01.CAMBRIDGEGRID100_04',
      'label': 'WMS Service Label'
    )
  end
  let(:blank_reference) do
    described_class.new(nil)
  end
  describe '#endpoint' do
    it 'returns the endpoint url for a reference' do
      expect(typical_reference.endpoint).to eq 'http://geoserver01.uit.tufts.edu/wms'
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
  describe '#layer_id' do
    it 'returns the layer WMS id' do
      expect(typical_reference.layer_id).to eq 'sde:GISPORTAL.GISOWNER01.CAMBRIDGEGRID100_04'
    end
  end
  describe '#label' do
    it 'returns the layer label' do
      expect(typical_reference.label).to eq 'WMS Service Label'
    end
  end
  describe '#to_hash' do
    it 'creates a hash using type and endpoint' do
      expect(typical_reference.to_hash).to eq wms: 'http://geoserver01.uit.tufts.edu/wms'
    end
  end
end
