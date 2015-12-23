require 'spec_helper'

describe Geoblacklight::SolrDocument::Inspection do
  let(:subject) { SolrDocument.new }
  describe '#inspectable?' do
    it 'returns true for wms viewer protocol' do
      expect(subject).to receive(:viewer_protocol).and_return('wms')
      expect(subject.inspectable?).to be_truthy
    end

    it 'returns false for iiif viewer protocol' do
      expect(subject).to receive(:viewer_protocol).and_return('iiif')
      expect(subject.inspectable?).to be_falsy
    end
  end
end
