# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::MetadataTransformer do
  let(:klass) { instance_double(Class) }
  before do
    allow(metadata).to receive(:blank?).and_return(false)
    allow(metadata).to receive(:class).and_return(klass)
  end

  describe '.instance' do
    context 'with FGDC metadata' do
      subject do
        described_class.instance(metadata)
      end
      let(:metadata) { instance_double(Geoblacklight::Metadata::Fgdc) }

      before do
        allow(klass).to receive(:name).and_return('Geoblacklight::Metadata::Fgdc')
      end

      it 'initializes a Fgdc Object' do
        expect(subject).to be_a Geoblacklight::MetadataTransformer::Fgdc
      end
    end

    context 'with ISO19139 metadata' do
      subject do
        described_class.instance(metadata)
      end
      let(:metadata) { instance_double(Geoblacklight::Metadata::Iso19139) }

      before do
        allow(klass).to receive(:name).and_return('Geoblacklight::Metadata::Iso19139')
      end

      it 'initializes a Iso19139 Object' do
        expect(subject).to be_a Geoblacklight::MetadataTransformer::Iso19139
      end
    end

    context 'without a metadata type' do
      subject do
        described_class.instance(metadata)
      end
      let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }

      before do
        allow(klass).to receive(:name).and_return('Geoblacklight::Metadata::Base')
      end

      it 'defaults to the BaseTransformer Class' do
        expect(subject).to be_a Geoblacklight::MetadataTransformer::Base
      end
    end

    context 'with an invalid metadata type' do
      let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }

      before do
        allow(klass).to receive(:name).and_return('Geoblacklight::Metadata::Invalid')
      end

      it 'raises a TypeError' do
        expect { described_class.instance(metadata) }.to \
          raise_error Geoblacklight::MetadataTransformer::TypeError, /Metadata type .+ is not supported/
      end
    end
  end
end
