# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::MetadataTransformer::Base do
  describe '.new' do
    it 'raises an error for empty XML' do
      expect { described_class.new(nil) }.to raise_error Geoblacklight::MetadataTransformer::EmptyMetadataError
    end
  end

  context 'with metadata types without XSL Stylesheets' do
    subject { described_class.new(metadata) }
    let(:metadata) { instance_double(GeoCombine::Metadata) }
    describe '#transform' do
      before do
        allow(metadata).to receive(:to_html).and_raise(NoMethodError, 'undefined method `to_html\'')
      end
      it 'raises a transform error' do
        expect { subject.transform }.to raise_error Geoblacklight::MetadataTransformer::TransformError, /undefined method `to_html'/
      end
    end
  end

  context 'with metadata types with XSL Stylesheets but invalid HTML' do
    subject { described_class.new(metadata) }
    let(:metadata) { instance_double(GeoCombine::Metadata) }
    describe '#transform' do
      before do
        allow(metadata).to receive(:to_html).and_return('<invalid-html></invalid-html>')
      end
      it 'raises a transform error' do
        expect { subject.transform }.to raise_error Geoblacklight::MetadataTransformer::TransformError, 'Failed to extract the <body> child elements from the transformed metadata'
      end
    end
  end
end
