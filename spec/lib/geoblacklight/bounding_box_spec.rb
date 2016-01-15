require 'spec_helper'

describe Geoblacklight::BoundingBox do
  describe '#initialize' do
    it 'handles multiple input types as arguments' do
      expect(described_class.new('1', '1', '1', '1')).to be_an described_class
      expect(described_class.new(1, 2, 3, 3)).to be_an described_class
      expect(described_class.new(1.1, 2.1, 3.1, 3.1)).to be_an described_class
    end
  end
  describe '#to_envelope' do
    let(:example_box) { described_class.new(-160, -80, 120, 70) }
    it 'creates an envelope syntax version of the bounding box' do
      expect(example_box.to_envelope).to eq 'ENVELOPE(-160, 120, 70, -80)'
    end
  end
  describe '#from_rectangle' do
    let(:example_box) { described_class.from_rectangle('-160 -80 120 70') }
    it 'parses and creates a Geoblacklight::BoundingBox from a Solr lat-lon' do
      expect(example_box).to be_an described_class
      expect(example_box.to_envelope).to eq 'ENVELOPE(-160, 120, 70, -80)'
    end
    it 'checks for valididity' do
      expect { described_class.from_rectangle('-160 -80 120') }.to raise_error Geoblacklight::Exceptions::WrongBoundingBoxFormat
    end
  end
end
