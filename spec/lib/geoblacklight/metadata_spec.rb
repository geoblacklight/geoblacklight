# frozen_string_literal: true
require 'spec_helper'

describe Geoblacklight::Metadata do
  describe '.instance' do
    let(:reference) { instance_double(Geoblacklight::Reference) }
    context 'with an FGDC metadata reference' do
      before do
        allow(reference).to receive(:type).and_return('fgdc')
      end
      it 'constructs an Geoblacklight::Metadata::Fgdc instance' do
        expect(described_class.instance(reference)).to be_a Geoblacklight::Metadata::Fgdc
      end
    end

    context 'with an ISO19139 metadata reference' do
      before do
        allow(reference).to receive(:type).and_return('iso19139')
      end
      it 'constructs an Geoblacklight::Metadata::Iso19139 instance' do
        expect(described_class.instance(reference)).to be_a Geoblacklight::Metadata::Iso19139
      end
    end

    context 'with an html metadata reference' do
      before do
        allow(reference).to receive(:type).and_return('html')
      end
      it 'constructs an Geoblacklight::Metadata::Html instance' do
        expect(described_class.instance(reference)).to be_a Geoblacklight::Metadata::Html
      end
    end

    context 'with another metadata reference' do
      before do
        allow(reference).to receive(:type).and_return('unsupported')
      end
      it 'constructs an Geoblacklight::Metadata::Base instance' do
        expect(described_class.instance(reference)).to be_a Geoblacklight::Metadata::Base
      end
    end
  end
end
