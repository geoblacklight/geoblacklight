require 'spec_helper'

describe Geoblacklight::Metadata::Html do
  let(:url) { 'https://s3.amazonaws.com/cugir-data/00/77/41/fgdc.html' }
  let(:metadata) do
    described_class.new(
      Geoblacklight::DctReference.new(
        ['http://www.w3.org/1999/xhtml', url]
      )
    )
  end

  describe '#transform' do
    it 'renders an iframe with the html endpoint' do
      expect(metadata.transform).to include('iframe', url)
    end
  end
end
