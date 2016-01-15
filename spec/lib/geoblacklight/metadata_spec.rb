require 'spec_helper'

describe Geoblacklight::Metadata do
  let(:response) { double('response') }
  let(:get) { double('get') }
  let(:opengeometadata) do
    described_class.new(
      Geoblacklight::Reference.new(
        ['http://www.loc.gov/mods/v3', 'http://purl.stanford.edu/cg357zz0321.mods']
      )
    )
  end
  describe '#retrieve_metadata' do
    it 'returns response from an endpoint url' do
      expect(response).to receive(:get).and_return(get)
      expect(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(response)
      opengeometadata.retrieve_metadata
    end
    it 'returns nil when a connection error' do
      expect(response).to receive(:get).and_return(Faraday::Error::ConnectionFailed)
      expect(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(response)
      opengeometadata.retrieve_metadata
    end
  end
end
