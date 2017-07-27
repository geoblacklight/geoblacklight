require 'spec_helper'

describe Geoblacklight::Metadata::Base do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response) }
  let(:opengeometadata) do
    described_class.new(
      Geoblacklight::Reference.new(
        ['http://www.loc.gov/mods/v3', 'http://purl.stanford.edu/cg357zz0321.mods']
      )
    )
  end

  describe '#document' do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
    end

    context 'with valid XML data at an endpoint URL' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('<test>data</test>')
        allow(connection).to receive(:get).and_return(response)
      end

      it 'returns an XML Document containing the payload from an endpoint url' do
        expect(opengeometadata.document).to be_a Nokogiri::XML::Document
      end
    end

    context 'when attempts to connect to an endpoint URL fail' do
      subject { opengeometadata.document }

      before do
        allow(connection).to receive(:get).and_raise(Faraday::Error::ConnectionFailed, 'test connection failures')
      end

      it 'returns nil when a connection error' do
        expect(subject).to be_a Nokogiri::XML::Document
        expect(subject.children.empty?).to be true
      end
    end
  end

  describe '#blank?' do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
    end

    context 'with valid XML data at an endpoint URL' do
      before do
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('<test>data</test>')
        allow(connection).to receive(:get).and_return(response)
      end

      it 'returns false' do
        expect(opengeometadata.blank?).to be false
      end
    end

    context 'when attempts to connect to an endpoint URL fail' do
      before do
        allow(connection).to receive(:get).and_raise(Faraday::Error::ConnectionFailed, 'test connection failures')
      end

      it 'returns true' do
        expect(opengeometadata.blank?).to be true
      end
    end
  end

  describe '#endpoint' do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://purl.stanford.edu/cg357zz0321.mods').and_return(connection)
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('<test>data</test>')
      allow(connection).to receive(:get).and_return(response)
    end

    it 'returns the URI' do
      expect(opengeometadata.endpoint).to eq 'http://purl.stanford.edu/cg357zz0321.mods'
    end
  end
end
