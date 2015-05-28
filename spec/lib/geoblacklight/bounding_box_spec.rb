require 'spec_helper'

describe Geoblacklight::BoundingBox do
  describe '#initialize' do
    it 'handles multiple input types as arguments' do
      expect(Geoblacklight::BoundingBox.new('1', '1', '1', '1')).to be_an Geoblacklight::BoundingBox
      expect(Geoblacklight::BoundingBox.new(1, 2, 3, 3)).to be_an Geoblacklight::BoundingBox
      expect(Geoblacklight::BoundingBox.new(1.1, 2.1, 3.1, 3.1)).to be_an Geoblacklight::BoundingBox
    end
  end
  describe '#to_envelope' do
    let(:example_box) { Geoblacklight::BoundingBox.new(-160, -80, 120, 70) }
    it 'creates an envelope syntax version of the bounding box' do
      expect(example_box.to_envelope).to eq 'ENVELOPE(-160, 120, 70, -80)'
    end
  end
  describe '#from_rectangle' do
    let(:example_box) { Geoblacklight::BoundingBox.from_rectangle('-160 -80 120 70') }
    it 'parses and creates a Geoblacklight::BoundingBox from a Solr lat-lon' do
      expect(example_box).to be_an Geoblacklight::BoundingBox
      expect(example_box.to_envelope).to eq 'ENVELOPE(-160, 120, 70, -80)'
    end
    it 'checks for valididity' do
      expect { Geoblacklight::BoundingBox.from_rectangle('-160 -80 120') }.to raise_error Geoblacklight::Exceptions::WrongBoundingBoxFormat
    end
  end
end
